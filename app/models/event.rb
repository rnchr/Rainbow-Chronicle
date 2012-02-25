class Event < ActiveRecord::Base
  include CommonHelper

  has_many :ratings, :dependent => :destroy, :class_name => 'EventRating'
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng
  
  after_validation :geocode, :reverse_geocode
  
  # for migration script
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :start, :end, :owner,
                  :picture, :created_at, :timespan, :type, :views, :website, :cached_rating
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def gmaps4rails_infowindow
      "<span style=\"font-weight:bold;\">#{title}</span><br>#{address}<br>Rating: #{aggregate}"
  end
end
