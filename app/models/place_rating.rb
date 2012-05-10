class PlaceRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                            :path => ":rails_root/public/system/place_ratings/:id/:style/:filename",
                            :url => "/system/place_ratings/:id/:style/:filename"
  
  def listing
    place
  end
  
  scope :last5, order("created_at DESC").limit(5)
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment, :photo
end
