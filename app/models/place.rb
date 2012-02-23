class Place < ActiveRecord::Base
  has_many :place_ratings, :dependent => :destroy
  belongs_to :user
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :hours_of_operation, :owner,
                  :picture, :created_at, :type, :views, :description, :website
                  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
end