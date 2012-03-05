require 'json'
require 'sequel'
require 'ap'
require 'iconv'

Global_keep = [:website, :phone, :address, :author, :post_ID, :_geoLat, :_geoLong, :photo, :_stateShort, :_city, :_zipcode]
Time_keep = [:sun_time_from, :sun_time_to, :mon_time_from, :mon_time_to,
  :tue_time_from,:tue_time_to,:wed_time_from,:wed_time_to,:thu_time_from,:thu_time_to,
  :fri_time_from,:fri_time_to,:sat_time_from,:sat_time_to]

class RainbowUser
  attr_accessor :name, :login, :email, :id, :events, :places,
	:leaders, :ratings, :comments, :news, :display_name
    
  def initialize(h)
    @h = h; @email = h[:user_email]; @created = h[:user_registered];
    @login = h[:user_login]
  	@id = h[:ID];	@name = h[:display_name];	@leaders = []
  	@events = [];	@news = [];	@places = [];	@ratings = []
  	@comments = []
  	get_all_posts
  end
  def get_all_posts
  	t = DB[:rb11_posts]
  	t.select_all.where(:post_author => @id, :post_status => 'publish').map do |p|
  		case p[:post_type]
  			when 'page'
  				# discard 
  			when 'places'
  				add_place p
  			when 'leaders'
  				add_leader p
  			when 'events'
  				add_event p
  			when 'news'
  				add_news p
  			end	
  	end	
  end
  def add_place(p)
    keep = [ *Global_keep, *Time_keep, :owner, :review_type]
    @places << parse_meta(p, keep)
  end  
  def add_leader(p)
    keep = [*Global_keep]
    @leaders << parse_meta(p, keep)
  end
  def add_event(p)
    keep = [*Global_keep, *Time_keep, :date_starts, :date_ends, :owner]
    @events << parse_meta(p, keep)
  end
  def add_news(p)
    keep = [*Global_keep, :post_link, :post_image]
    @news << parse_meta(p, keep)
  end
  
  def parse_meta(pid, keep=Global_keep)
  	t = DB[:rb11_postmeta]
  	obj = {}
  	obj[:post_ID] = pid[:ID]
  	obj[:author] = pid[:post_author]
  	obj[:title] = pid[:post_title]
  	obj[:body] = pid[:post_content]
  	obj[:created_at] = pid[:post_date]
  	obj[:views] = get_views(pid[:ID])
  	obj[:lock] = (pid[:comment_status] != 'open')
  	
  	t.select_all.where(:post_id => pid[:ID]).map do |m|
  	  the_sym = m[:meta_key].to_sym
  		obj[the_sym] = m[:meta_value] unless m[:meta_value].empty? or !keep.include? the_sym
  	end
  	obj
  end
  
  def get_views(id)
    p = DB[:rb11_post_views][:ID => id]
    return p[:total_views] if p
    0
  end

  def self.format_hours(h)
    str = ""
    unless h[:mon_time_from].nil?
      str << "Monday: #{h[:mon_time_from]}"
      str << " to #{h[:mon_time_to]}\n" unless h[:mon_time_to].nil?
    end
    unless h[:tue_time_from].nil?
      str << "Tuesday: #{h[:tue_time_from]}"
      str << " to #{h[:tue_time_to]}\n" unless h[:tue_time_to].nil?
    end
    unless h[:wed_time_from].nil?
      str << "Wednesday: #{h[:wed_time_from]}"
      str << " to #{h[:wed_time_to]}\n" unless h[:wed_time_to].nil?
    end
    unless h[:thu_time_from].nil?
      str << "Thursday: #{h[:thu_time_from]}"
      str << " to #{h[:thu_time_to]}\n" unless h[:thu_time_to].nil?
    end
    unless h[:fri_time_from].nil?
      str << "Friday: #{h[:fri_time_from]}"
      str << " to #{h[:fri_time_to]}\n" unless h[:fri_time_to].nil?
    end
    unless h[:sat_time_from].nil?
      str << "Saturday: #{h[:sat_time_from]}"
      str << " to #{h[:sat_time_to]}\n" unless h[:sat_time_to].nil?
    end
    unless h[:sun_time_from].nil?
      str << "Sunday: #{h[:sun_time_from]}"
      str << " to #{h[:sun_time_to]}\n" unless h[:sun_time_to].nil?
    end
    str
  end

  def gen_user_hash
    {:id => @id, :display_name => @name, :password => "defaultpass", :email => @email,
            :created_at => @created, :login => @login}
  end
  
  def self.dhelp(d)
    begin
      return Date.strptime(d, "%m/%d/%Y")
    rescue
      return Date.today()
    end
  end
  
  def self.uni_helper!(p)
    ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
    if p[:body]
      p[:body] = ic.iconv p[:body]
    end
    if p[:title]
      p[:title] = ic.iconv p[:title]
    end
  end
  
  def self.to_url(u)
    u =~ /^www/ ? "http://#{u}" : u
  end
  
  def self.gen_event_hash(p)
    uni_helper! p
    {:id => p[:post_ID], :user_id => p[:author], :title => p[:title], 
      :lat => p[:_geoLat], :lng => p[:_geoLong], :address => p[:address],
      :start => dhelp(p[:date_starts]), :end => dhelp(p[:date_ends]), :owner => p[:owner],
      :picture => p[:photo], :created_at => p[:created_at], :website => to_url(p[:website]),
      :timespan => format_hours(p), :views => p[:views], :city => p[:_city], :state => p[:_stateShort], :zipcode => p[:_zipcode]}
  end
  
  def self.gen_place_hash(p)
    uni_helper! p
    {
     :id => p[:post_ID], :user_id => p[:author], :title => p[:title], 
     :lat => p[:_geoLat], :lng => p[:_geoLong], :address => p[:address],
     :picture => p[:photo], :created_at => p[:created_at], :views => p[:views],
     :hours_of_operation => format_hours(p), :website => to_url(p[:website]),
     :type => p[:review_type], :owner => p[:owner], :phone => p[:phone], :city => p[:_city], :state => p[:_stateShort], :zipcode => p[:_zipcode]
    }
  end
  
  def self.gen_leader_hash(p)
    uni_helper! p
    {
      :id => p[:post_ID], :user_id => p[:author], :title => p[:title], 
      :lat => p[:_geoLat], :lng => p[:_geoLong], :address => p[:address],
      :picture => p[:photo], :created_at => p[:created_at], :views => p[:views],
      :website => to_url(p[:website]), :phone => p[:phone], :city => p[:_city], :state => p[:_stateShort], :zipcode => p[:_zipcode]
    }
  end

  def self.gen_news_hash(p)
    uni_helper! p
    {
      :id => p[:post_ID], :user_id => p[:author], :title => p[:title],
      :views => p[:views], :photo => p[:post_image], :link => to_url(p[:post_link]),
      :body => p[:body], :lock => p[:lock]
    }
  end
end


