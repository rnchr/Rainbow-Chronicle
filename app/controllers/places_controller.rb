class PlacesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_and_check_permission, :only => [:update, :edit, :destroy]

  def index
      @all_places = Place.near(@location)
      @places = @all_places.page(params[:page]).per(10)
      @json = @all_places.to_gmaps4rails
      state = Place.where(:state => @state)
      @in_state = state.ordered_cities
      @state_count = @in_state.inject(0) {|sum, city| sum + city.c}
      @nearbys = @all_places.ordered_cities.sort {|a,b| b.c <=> a.c}[0...5]
      @top_national = Place.top_national
  end

  def show
    @place = Place.find(params[:id])
    @ratings = @place.ratings.map do |r|
      rating_helper r
    end
    @rating = @place.ratings.new 
    if @place.rating_set.eql? "corporate"
      @rating_questions = Rating.where(:for => "places")
    else
      @rating_questions = Rating.where(:for => "places", :set => 0)
    end
  end

  def new
    @place = Place.new
  end

  def edit
    @place = Place.find(params[:id])
  end

  def create
    @place = Place.new(params[:place])
    @place.user = current_user
    if @place.save
      redirect_to @place, notice: 'Place was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @place = Place.find(params[:id])
    if @place.update_attributes(params[:place])
      redirect_to @place, notice: 'Place was successfully updated.'
    else
      render action: "edit"
    end
  end
  
  def popular
    @all_places = Place.popular.near(@location, 15)
    @json = @all_places.to_gmaps4rails
    @places = @all_places.page(params[:page]).per(10)
  end
  
  def unsafe
    @all_places = Place.where("cached_rating < 1").order("cached_rating ASC").near(@location, 15)
    @json = @all_places.to_gmaps4rails
    @places = @all_places.page(params[:page]).per(10)
    render 'popular'
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to places_path
  end
  
  private
  def authenticate_and_check_permission
    authenticate_user!
    @place = Place.find(params[:id])
    unless current_user.admin? or current_user.eql? @place.user
      redirect_to @place, notice: "You don't have permission to modify this record."
    end
  end

end
