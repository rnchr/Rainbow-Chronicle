class Leader < ActiveRecord::Base
  include CommonHelper
  
  has_many :ratings, :dependent => :destroy, :class_name => "LeaderRating"
  has_many :leader_categories
  has_many :leader_types, :through => :leader_categories
  
  def tags
    leader_types
  end
  
  belongs_to :user
  
  attr_accessible :id, :user_id, :title, :lat, :lng, :address,
                  :picture, :created_at, :type, :views, :website, :cached_rating
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng

  before_create :geocode
end
