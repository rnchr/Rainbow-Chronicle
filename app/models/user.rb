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
  has_one :ranking
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
    self.fb_token = omniauth['credentials']['fb_token'] if !omniauth['credentials']['token'].nil?
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
  
  def self.update_token(omniauth, user_id)
    user = User.find(user_id)
    user.fb_token = omniauth['credentials']['token']
    user.save  
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
    my_old_rank = 0
    
    incumbents.each do |inc|
      if inc.user == self 
         my_old_rank = inc.place
         break
      end
    end
    
    
    if incumbents.empty? 
      my_title = Title.new(:user_id => self.id, :city => city, :state => state, :name => "Marshal", :place => 1)
      my_title.save
      return 
    else
      if my_old_rank != 0
        incumbents.delete_if {|i| i.user == self}
      end  
      latest_counts = get_incumbent_star_counts(incumbents, city, state) 
      unique_counts = latest_counts.uniq
      if unique_counts.size == 2
        unique_counts << 0
      end
      if unique_counts.size == 1
        2.times do
          unique_counts << 0 
        end
      end  
      
      counter = 1
      unique_counts.each do |uc|
        if my_count > uc
          my_place = counter
          #anything with rank==3 should be deleted here

          thirds = incumbents.find_all{|i| i.place == 3}
          unless thirds.empty?
            thirds.each do |t|
              t.destroy
            end
          end
          
          if my_place >= 2
            seconds = incumbents.find_all{|i| i.place == 2}
            unless seconds.empty?
              seconds.each do |s|
                s.place += 1
                s.assign_title(3)
                s.save
              end
            end
          end  

          if my_place >= 1
            seconds = incumbents.find_all{|i| i.place == 2}
            unless seconds.empty?
              seconds.each do |s|
                s.place += 1
                s.assign_title(3)
                s.save
              end
            end
            
            firsts = incumbents.find_all{|i| i.place == 1}
            unless firsts.empty?
              firsts.each do |f|
                f.place += 1
                f.assign_title(2)
                f.save
              end
            end
            
          end  
          
          if my_old_rank != 0
            my_old_title = Title.find_by_user_id_and_city_and_state(self.id, city, state) #why not just assign everything here??
            my_old_title.place = my_place
            my_old_title.assign_title(my_place)
            my_old_title.save
          else 
            my_title = Title.new(:user_id => self.id, :city => city, :state => state, :place => my_place)
            my_title.save
            my_title.assign_title(my_place)
          end
          
          break
          
        elsif my_count == uc
          my_place = counter
          seconds = incumbents.find_all{|i| i.place == 2}
          thirds = incumbents.find_all{|i| i.place == 3}
          if seconds.empty? && my_place != 2
            thirds = incumbents.find_all{|i| i.place == 3}
            thirds.each do |t|
              t.place = 2
              t.assign_title(2)
              t.save
            end
          end
          
          #if thirds.empty? && my_place != 3
            #promote some user without a title to third place spot
          #end          
               
          if my_old_rank != 0
            my_old_title = Title.find_by_user_id_and_city_and_state(self.id, city, state) #why not just assign everything here??
            my_old_title.place = my_place
            my_old_title.assign_title(my_place)
            my_old_title.save
            break
          else 
            my_title = Title.new(:user_id => self.id, :city => city, :state => state, :place => my_place)
            my_title.save
            my_title.assign_title(my_place)
            break
          end       
          
        end  
        counter += 1
      end
    
    end #incumbents not empty if
          
  end #method
  
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
    return counts
  end  
    
  def announce_on_fb(obj, event, link)
    if event == "create"
      begin
        @graph = Koala::Facebook::API.new(self.fb_token)
        @graph.put_wall_post("I just added " + obj.title + " to RainbowChronicle.com!", :link => link )
      rescue
      end  
    elsif event == "rate"
      begin
        @graph = Koala::Facebook::API.new(self.fb_token)
        @graph.put_wall_post("I just rated " + obj.title + " on RainbowChronicle.com!", :link => link )
      rescue
      end  
    end    
  end
  
  def announce_signup
    begin
      @graph = Koala::Facebook::API.new(self.fb_token)
      @graph.put_wall_post("I just signed up for Rainbow Chronicle to review People, Places and Events based on LGBT friendliness", :link => root_url )
    rescue
    end
  end
    
    
    
    
    
    
    
    
end
