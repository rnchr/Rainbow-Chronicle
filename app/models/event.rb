class Event < ActiveRecord::Base
  has_many :ratings, :dependent => :destroy, :class_name => 'EventRating'
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
  
  # for migration script
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :start, :end, :owner,
                  :picture, :created_at, :timespan, :type, :views, :website
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def aggregate
    ratings.average(:rating).to_f
  end
  
  def gmaps4rails_infowindow
      "<span style=\"font-weight:bold;\">#{title}</span><br>#{address}<br>Rating: #{rating}"
  end
end
