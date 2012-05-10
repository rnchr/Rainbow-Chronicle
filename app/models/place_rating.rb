class PlaceRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  
  
  
  def listing
    place
  end
  
  scope :last5, order("created_at DESC").limit(5)
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment
end
