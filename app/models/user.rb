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
  validates :display_name, :presence => true
  
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
  has_many :titles
  has_many :stars
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

  def self.confirm_or_add_image(omniauth, user_id)
    user=User.find(user_id)
    unless user.avatar?
      unless omniauth["info"]["image"].nil?
        user.fb_image = omniauth["info"]["image"]
        user.save
      end
    end
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def add_stars(city, state, stars_to_add)
    stars_to_add.times do 
      noob=Star.new(:user_id => self.id, :city => city, :state => state, :awarded => stars_to_add)
      noob.save
    end
    self.am_i_famous(city, state)
  end  
  
  def am_i_famous(city, state)
    my_count = self.stars.where(:city => city, :state => state).size
    #it's still measuring against 1st even if 2nd and 3rd are empty!
    #FETCH ASSOCIATED USERS/STARS AND ORDER RESULTS APPROPRIATELY
    incumbents = Title.includes(:user => :stars).order("place ASC").find_all_by_city_and_state(city, state)
    if incumbents.empty? 
      my_title = Title.new(:user_id => self.id, :city => city, :state => state, :name => "Marshal", :place => 1)
      my_title.save
      return 
    else
      latest_counts = get_incumbent_star_counts(incumbents, city, state)
      my_place = self.find_my_place(my_count, latest_counts, incumbents)
      unless my_place == 0
        my_title = Title.new(:user_id => self.id, :city => city, :state => state, :place => my_place)
        my_title.save
        self.assign_title(my_title, my_place)
      end  
    end
  end

  def get_incumbent_star_counts(incumbents, city, state)
    counts = []
    incumbents.each do |i|
      city_stars =[]
      i.user.stars.each do |star|
        if star.city == city && star.state == state
          city_stars << star
        end
      end
      counts << city_stars.size
    end
    if counts.size == 1
      2.times do
        counts << 0
      end
    elsif counts.size == 2
      counts << 0
    end
    return counts
  end
  
  def find_my_place(my_count, latest_counts, incumbents)
    my_place = 0
    i = 1
    latest_counts.each do |l|
      if my_count > l
        my_place = i
        self.reassign_incumbents(incumbents, my_place)
        return my_place
      elsif my_count == l 
        my_place = i
        if incumbents[i-1].user == self
          incumbents[i-1].destroy
        end   
        return my_place
      end
      i += 1
    end
    return my_place
  end
  
  def reassign_incumbents(incumbents, my_place)
    incumbents.each do |i|
      if i.place >= my_place
        unless i.place == 3
          if i.user == self
            i.destroy
            return
          end
          i.place += 1
          i.save
          assign_title(i, i.place)
        end
        if i.place == 3
          i.destroy
        end
      end
    end
  end
    
  
  def assign_title(title_object, place)
    if place == 1
      title_object.name = "Marshal"
      title_object.save
    elsif place == 2
      title_object.name = "Sheriff"
      title_object.save
    elsif place == 3
      title_object.name = "Deputy"
      title_object.save
    end
  end 

end
