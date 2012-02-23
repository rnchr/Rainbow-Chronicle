class Leader < ActiveRecord::Base
  has_many :leader_ratings, :dependent => :destroy
  belongs_to :user
  
  attr_accessible :id, :user_id, :title, :lat, :lng, :address,
                  :picture, :created_at, :type, :views, :website
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
end
