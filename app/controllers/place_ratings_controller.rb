class PlaceRatingsController < ApplicationController
  include RatingsHelper
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    redirect_to place_path (params[:place_id])
  end
  
  def create
    @place = Place.find params[:place_id]
    
    if @place.users.include? current_user
      redirect_to @place, notice: "You've already rated this place! Please edit your existing rating instead."
      return
    end

    @rating = @place.ratings.new
    @rating.review, overall, count = parse_review params
    @rating.comment = params[:comment]
    @rating.user = current_user
    @rating.overall = if count > 0 then (overall.to_f/count) else 0 end
      
    if @rating.save
      @place.aggregate!
      redirect_to @place
    else
      redirect_to places_path, notice: "Unable to save your review."
    end
  end
  
  def edit
    
  end
  
  def destroy
    rating = PlaceRating.find(params[:rating_id])
    place = Place.find(params[:place_id])
    if current_user.admin? or rating.user.eql? current_user
      rating.destroy
      redirect_to places_path(place), notice: "Your rating has been deleted."
    else
      redirect_to places_path(place), notice: "You don't have permission to do that."
    end
  end
end