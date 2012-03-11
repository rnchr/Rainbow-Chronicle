class Event < ActiveRecord::Base
  include CommonHelper

  has_many :ratings, :dependent => :destroy, :class_name => 'EventRating'
  has_many :event_categories
  has_many :event_types, :through => :event_categories
  belongs_to :user
  
  has_attached_file :photo, :styles => { :medium => "370x370>", :thumb => "75x75>" }
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng

  scope :popular, where("cached_rating > 2.5").order("cached_rating DESC")
  scope :ordered_cities, select("city, state, count(city) as c").group(:city).order("c desc")
  scope :top_national, ordered_cities.limit(3)

  before_create :geocode
  # 
  # # for migration script
  # attr_accessible :id, :user_id, :title, :lat, :lng, :address, :start, :end, :owner, :phone,
  #                 :picture, :created_at, :timespan, :type, :views, :website, :cached_rating, :state, :city, :zipcode
  # 
  def tags
    event_types
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
