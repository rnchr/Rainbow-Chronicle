class Place < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "PlaceRating"
  belongs_to :user
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :hours_of_operation, :owner,
                  :picture, :created_at, :type, :views, :description, :website, :cached_rating
                  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng
  
  after_validation :geocode, :reverse_geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
end