class Leader < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "LeaderRating"
  has_many :leader_categories
  has_many :leader_types, :through => :leader_categories
  
  def tags
    leader_types
  end
  
  belongs_to :user
  # 
  # attr_accessible :id, :user_id, :title, :lat, :lng, :address, :phone, 
  #                 :picture, :created_at, :type, :views, :website, :cached_rating, :state, :city, :zipcode
  # 
  geocoded_by :address, :latitude => :lat, :longitude => :lng

  # before_create :geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def gmaps4rails_marker_picture
   {
    "picture" => rating_icon('leader'),          # string, mandatory
     "width" =>  41,          # string, mandatory
     "height" => 41,          # string, mandatory
   }
  end
end
