class Place < ActiveRecord::Base
  has_many :place_ratings
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
end