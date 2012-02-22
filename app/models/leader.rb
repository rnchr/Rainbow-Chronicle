class Leader < ActiveRecord::Base
  has_many :leader_ratings, :dependent => :destroy
  belongs_to :user
  
  geocoded_by :address, :latitude => :lat, :longitude => :lng
  after_validation :geocode
end
