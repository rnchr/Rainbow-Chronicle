class FeaturedController < ApplicationController
  before_filter :authenticate_user!
  before_filter :verify_rc_elite
  
  def city_featured
    obj_type = params[:type]
    obj_id = params[:obj_id]
    bool_time = params[:bool_time]
    
    if obj_type == 'Place'
      featured = Place.find(obj_id)
      featured.city_featured = bool_time
      featured.save
    elsif obj_type == 'Leader'
      featured = Leader.find(obj_id)
      featured.city_featured = bool_time
      featured.save  
    end          
    
    redirect_to place_path(obj_id)
  end 
  
  def category_featured
    obj_type = params[:type]
    obj_id = params[:obj_id]
    bool_time = params[:bool_time]
    
    if obj_type == 'Place'
      featured = Place.find(obj_id)
      featured.category_featured = bool_time
      featured.save
    elsif obj_type == 'Leader'
      featured = Leader.find(obj_id)
      featured.category_featured = bool_time
      featured.save  
    end          
    
    redirect_to place_path(obj_id)
  end
  
  
end
