class Event < ActiveRecord::Base
  has_many :event_ratings
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng'
end
