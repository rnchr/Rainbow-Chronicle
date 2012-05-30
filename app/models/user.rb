class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :display_name,
                  :login, :first_name, :last_name, :url, :location, :avatar, :facebook_link,
                  :twitter_link, :bio, :fb_image
                  
  validates_length_of :bio, :maximum => 140, :message => 'Maximum length is 140 characters. Make it count!'
  
  geocoded_by :location, :latitude => :lat, :longitude => :lng
  reverse_geocoded_by :lat, :lng, :address => :location
  after_validation :reverse_geocode
  
  before_update :geocode
  
  has_attached_file :avatar, :styles => { :medium => ["250x300>", :png], :thumb => ["50x50>", :png] }
  
  has_many :events
  has_many :places
  has_many :leaders
  has_many :authentications
  has_many :event_ratings
  has_many :leader_ratings
  has_many :place_ratings
  
  has_many :comments
  
  # recent_activities
  # takes optional argument n, for how many results to return 
  # returns list of n most recent site actions
  def recent_reviews(n=5)
     all = event_ratings.order("created_at desc").limit(n) + leader_ratings.order("created_at desc").limit(n) + place_ratings.order("created_at desc").limit(n)
     all.sort {|a,b| b.created_at <=> a.created_at }[0...n]
  end
  
  def recent_listings(n=5)
    all = events.order("created_at desc").limit(n) + places.order("created_at desc").limit(n) + leaders.order("created_at desc").limit(n)
    all.sort {|a,b| b.created_at <=> a.created_at }[0...n] 
  end

  def recent_comments(n=5)
    comments.order("created_at desc").limit(n)
  end
  
  def apply_omniauth(omniauth)
    self.email = omniauth['info']['email'] if email.blank?
    self.first_name = omniauth['info']['first_name'] if first_name.blank?
    self.display_name = omniauth['info']['first_name'] if display_name.blank?
    self.last_name = omniauth['info']['last_name'] if last_name.blank?
    self.location = omniauth['info']['location'] if location.blank? && !omniauth['info']['location'].nil?
    self.fb_image = omniauth['info']['image'] if fb_image.blank? && !omniauth['info']['image'].nil?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

end
