class CategoriesController < ApplicationController
  before_filter :initialize_type
  
  def show
    @category = params[:category]
    @path = @klass.where(:name => @category).first.ancestry_path
    @all = @klass.related_to(@category, @location[:ll]).sort {|a,b| a.distance <=> b.distance }
    @json = @all.to_gmaps4rails
    @items = Kaminari.paginate_array(@all).page(params[:page]).per(10)
  end
  
  private
  
  def initialize_type
    @klass = case params[:type]
    when 'places'
      PlaceType
    when 'events'
      EventType
    when 'leaders'
      LeaderType
    else
      not_found
    end
  end
end