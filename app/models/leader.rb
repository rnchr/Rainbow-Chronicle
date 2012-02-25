class Leader < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "LeaderRating"
  belongs_to :user
  
  attr_accessible :id, :user_id, :title, :lat, :lng, :address,
                  :picture, :created_at, :type, :views, :website, :cached_rating
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng

  after_validation :geocode, :reverse_geocode
end
