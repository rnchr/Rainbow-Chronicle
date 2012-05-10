class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :display_name,
                  :login, :first_name, :last_name, :url, :location, :avatar
  
  geocoded_by :location, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng, :address => :location
  after_validation :reverse_geocode
  
  before_update :geocode
  
  has_attached_file :avatar, :styles => { :medium => ["250x300>", :png], :thumb => ["50x50>", :png] }
  
  has_many :events
  has_many :places
  has_many :leaders
  
  has_many :event_ratings
  has_many :leader_ratings
  has_many :place_ratings
  
  has_many :comments
  
  # recent_activities
  # takes optional argument n, for how many results to return
  # returns list of n most recent site actions
  def recent_reviews(n=5)
     all = event_ratings.order("created_at desc").limit(n) + leader_ratings.order("created_at desc").limit(n) + place_ratings.order("created_at desc").limit(n)
     all.sort {|a,b| a.created_at <=> b.created_at }[0...n]
  end
  
  def recent_listings(n=5)
    all = events.order("created_at desc").limit(n) + places.order("created_at desc").limit(n) + leaders.order("created_at desc").limit(n)
    all.sort {|a,b| a.created_at <=> b.created_at }[0...n] 
  end

  def recent_comments(n=5)
    comments.order("created_at desc").limit(n)
  end
end
