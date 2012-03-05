class Place < ActiveRecord::Base
  include CommonHelper
  include PlacesHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "PlaceRating"
  has_many :place_categories
  has_many :place_types, :through => :place_categories
  
  def tags
    place_types
  end
  
  belongs_to :user
  attr_accessible :id, :user_id, :title, :lat, :lng, :address, :hours_of_operation, :owner, :rating_set, :phone,
                  :picture, :created_at, :type, :views, :description, :website, :cached_rating, :state, :city, :zipcode
                  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  
  before_create :geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def gmaps4rails_marker_picture
   {
    "picture" => rating_icon('place'),          # string, mandatory
     "width" =>  41,          # string, mandatory
     "height" => 41,          # string, mandatory
   }
  end
  
end