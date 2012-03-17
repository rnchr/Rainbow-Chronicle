class Event < ActiveRecord::Base
  include CommonHelper

  has_many :ratings, :dependent => :destroy, :class_name => 'EventRating'
  has_many :event_categories
  has_many :event_types, :through => :event_categories
  belongs_to :user
  has_many :users, :through => :ratings
  
  
  has_attached_file :photo, :styles => { :medium => "370x370>", :thumb => "75x75>", :url => "/system/:hash.:extension",
      :hash_secret => "event_secret" }
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode,
    :if => lambda{ |obj| obj.address_changed? }
  scope :popular, where("cached_rating > 2.5").order("cached_rating DESC")
  scope :ordered_cities, select("city, state, count(city) as c").group(:city).order("c desc")
  scope :top_national, ordered_cities.limit(3)

  before_create :geocode
  
  # for migration script
  attr_accessible :title, :lat, :lng, :address, :start, :end, :owner, :phone,
                  :picture, :created_at, :timespan, :views, :website, :state, :city, :zipcode, :photo,
                  :photo_file_name, :photo_content_type, :photo_file_size, :photo_updated_at
  
  def tags
    event_types
  end
  
  def self.tag_type
    EventRating
  end
  
  acts_as_gmappable :lat => 'lat', :lng => 'lng', :address => 'address'
  
  def gmaps4rails_marker_picture
   {
    "picture" => rating_icon('event'),          # string, mandatory
     "width" =>  41,          # string, mandatory
     "height" => 41,          # string, mandatory
   }
  end
end
