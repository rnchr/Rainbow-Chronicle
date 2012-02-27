class Event < ActiveRecord::Base
  include CommonHelper

  has_many :ratings, :dependent => :destroy, :class_name => 'EventRating'
  has_many :event_categories
  has_many :event_types, :through => :event_categories
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  
  before_create :geocode
  
  # for migration script
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :start, :end, :owner,
                  :picture, :created_at, :timespan, :type, :views, :website, :cached_rating
  
  def tags
    event_types
  end
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
end
