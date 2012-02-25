class PlaceRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :place
  belongs_to :rating
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment
end
