class PlacesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create]
  before_filter :authenticate_and_check_permission, :only => [:update, :edit, :destroy]

  def index
     if params[:zip].present?
        @all_places = Place.near(params[:zip], 15)
        @city = Geocoder.search(params[:zip])
      else
        @all_places = Place.near([42.413454,-71.1088269], 15)
      end
      @places = @all_places.page(params[:page]).per(10)
      @json = @all_places.to_gmaps4rails
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

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @place }
    end
  end

  def edit
    @place = Place.find(params[:id])
  end

  def create
    @place = Place.new(params[:place])
    if @place.save
      redirect_to @place, notice: 'Place was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @place = Place.find(params[:id])

    respond_to do |format|
      if @place.update_attributes(params[:place])
        format.html { redirect_to @place, notice: 'Place was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  def category
    
  end
  
  def popular
    @all_places = Place.where("cached_rating > 1").order("cached_rating DESC").near([42.413454,-71.1088269], 15)
    @json = @all_places.to_gmaps4rails
    @places = @all_places.page(params[:page]).per(10)
  end
  
  def unsafe
    @all_places = Place.where("cached_rating < 1").order("cached_rating ASC").near([42.413454,-71.1088269], 15)
    @json = @all_places.to_gmaps4rails
    @places = @all_places.page(params[:page]).per(10)
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
  end
  
  private
  def authenticate_and_check_permission
    authenticate!
    @place = Place.find(params[:id])
    unless current_user.admin? or current_user.eql? @place.user
      redirect_to @place, notice: "You don't have permission to modify this record."
    end
  end
end
