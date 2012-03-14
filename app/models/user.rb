class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :display_name,
                  :login, :first_name, :last_name, :url, :location
  
  geocoded_by :location, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng,
    :address => :location
  after_validation :reverse_geocode
  before_update :geocode
  
  has_many :events
  has_many :places
  has_many :leaders
  
  has_many :event_ratings
  has_many :leader_ratings
  has_many :place_ratings
  
  has_many :comments
end
