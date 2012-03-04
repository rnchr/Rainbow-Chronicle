class PlaceRatingsController < ApplicationController
  def index
    redirect_to place_path (params[:place_id])
  end
  
  def create
    @place = Place.find params[:place_id]
    @rating = @place.ratings.new
    review = param[:rating].inject([]) do |rev, kv|
      rev << {"rating_id" => kv[0], "value" => kv[1].to_i}
    end.to_json
    render params.inspect
    #redirect_to place_path (params[:place_id])
  end
  
  def edit
    
  end
  
  def destroy
    
  end
end