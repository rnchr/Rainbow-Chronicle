class PlacesController < ApplicationController
  before_filter :authenticate_user!, :only => [:new, :create, :update, :edit, :destroy]

  # GET /places
  # GET /places.json
  def index
     if params[:zip].present?
        @all_places = Place.near(params[:zip], 15, :order => :distance)
        @city = Geocoder.search(params[:zip])
      else
        @city = Geocoder.search("Eiffel Tower")
        @all_places = Place.near([42.413454,-71.1088269], 15)
      end
      @places = @all_places.page(params[:page]).per(10)
      @json = @all_places.to_gmaps4rails
  end

  # GET /places/1
  # GET /places/1.json
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

  # GET /places/new
  # GET /places/new.json
  def new
    @place = Place.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @place }
    end
  end

  # GET /places/1/edit
  def edit
    @place = Place.find(params[:id])
  end

  # POST /places
  # POST /places.json
  def create
    @place = Place.new(params[:place])

    respond_to do |format|
      if @place.save
        format.html { redirect_to @place, notice: 'Place was successfully created.' }
        format.json { render json: @place, status: :created, location: @place }
      else
        format.html { render action: "new" }
        format.json { render json: @place.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /places/1
  # PUT /places/1.json
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

  # DELETE /places/1
  # DELETE /places/1.json
  def destroy
    @place = Place.find(params[:id])
    @place.destroy

    respond_to do |format|
      format.html { redirect_to places_url }
      format.json { head :no_content }
    end
  end
end
