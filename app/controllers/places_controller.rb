class PlacesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_and_check_permission, :only => [:update, :edit, :destroy]
  before_filter :set_active
  def index
      set_all_index_vars
  end

  def show
    @place = Place.find(params[:id])
    @ratings = @place.ratings #.map {|r| rating_helper r }
    # @rating = @place.ratings.new 
    
    # this is ugly. fix it later.
    if @place.rating_set.eql? "corporate"
      @rating_questions = Rating.where(:for => "places")
    else
      @rating_questions = Rating.where(:for => "places", :set => 0)
    end
  end

  def new
    @place = Place.new
    set_category_vars PlaceType
  end

  def edit
    @place = Place.find(params[:id])
    set_category_vars PlaceType
    
    unless can? :edit, @place
      redirect_to @place, notice: "You don't have permission to modify this record."
      return
    end
  end

  def create
    @place = Place.new(params[:place])
    unless params[:categories].nil?
      @place.tags << params[:categories].collect {|c| PlaceType.find(c) }
    end      
    @place.user = current_user
    if @place.save
      current_user.add_stars(@place.city, 2)
      redirect_to @place, notice: 'Place was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @place = Place.find(params[:id])
    unless params[:categories].nil?
      @place.tags << params[:categories].collect {|c| PlaceType.find(c) }
    end
    if @place.update_attributes(params[:place])
      redirect_to @place, notice: 'Place was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def popular
    set_popular_vars
    render 'shared/popular'
  end
  
  def unsafe
    set_unsafe_vars
    render 'shared/popular'
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to places_path
  end
  
  private
  def klass; @klass = Place; end
  def class_name; 'places'; end
  
  def set_active
    @active = "Place"
  end

end
