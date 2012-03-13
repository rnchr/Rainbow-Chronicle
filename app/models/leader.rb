class Leader < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "LeaderRating"
  has_many :leader_categories
  has_many :leader_types, :through => :leader_categories
  belongs_to :user
  
  def tags
    leader_types
  end
  
  def self.tag_type
    LeaderRating
  end
  
  scope :popular, where("cached_rating > 2.5").order("cached_rating DESC")
  scope :ordered_cities, select("city, state, count(city) as c").group(:city).order("c desc")
  scope :top_national, ordered_cities.limit(3)
  has_attached_file :photo, :styles => { :medium => "370x370>", :thumb => "75x75>", :url => "/system/leaders/:id" }
  
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
