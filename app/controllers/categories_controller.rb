class CategoriesController < ApplicationController
  before_filter :initialize_type
  before_filter :verify_admin, :only => [:create]
  
  def show
    @category = params[:category]
    @path = @klass.where(:name => @category).first.ancestry_path
    @all = @klass.related_to(@category, @location[:ll]).sort_by { |a| a.category_featured ? 0 : 1 }
    @json = @all.to_gmaps4rails
    @items = Kaminari.paginate_array(@all).page(params[:page]).per(10)
  end
  
  def create
    path = params[:existing_path].split(',')
    @klass.find_or_create_by_path([path, params[:new_category]].flatten)
    redirect_to admin_path
  end
  
  private
  
  def initialize_type
    @klass, @type = case params[:type]
    when 'places'
      [PlaceType, Place]
    when 'events'
      [EventType, Event]
    when 'leaders'
      [LeaderType, Leader]
    else
      not_found
    end
  end
end