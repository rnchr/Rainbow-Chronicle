class Leader < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "LeaderRating"
  has_many :leader_categories
  has_many :leader_types, :through => :leader_categories
  belongs_to :user
  has_many :users, :through => :ratings
  
  def tags
    leader_types
  end
  
  def self.tag_type
    LeaderRating
  end
  
  scope :popular, where("cached_rating > 2.5").order("cached_rating DESC")
  scope :ordered_cities, select("city, state, count(city) as c").group(:city).order("c desc")
  scope :top_national, ordered_cities.limit(3)
  has_attached_file :photo, :styles => { :medium => "370x370>", :thumb => "75x75>", :url => "/system/:hash.:extension",
      :hash_secret => "leaders_secret" }
  
  
  attr_accessible :title, :lat, :lng, :address, :phone, 
                  :picture, :type, :views, :website, :cached_rating, :state, :city, :zipcode,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at, :photo, :cached_rating
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode,
    :if => lambda{ |obj| obj.address_changed? }
  # before_create :geocode
  
  reverse_geocoded_by :lat, :lng do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zipcode = geo.postal_code
      obj.state = geo.province_code
    end
  end
  after_validation :reverse_geocode
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def gmaps4rails_marker_picture
   {
    "picture" => rating_icon('leader'),          # string, mandatory
     "width" =>  41,          # string, mandatory
     "height" => 41,          # string, mandatory
   }
  end
end
