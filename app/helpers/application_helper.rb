module ApplicationHelper
  # this is a big ugly view function that should be refactored
  def display_categories(objects)
    return unless objects.count > 0
    obj = objects.first
    threshold = 4
    list = {}
    objects.each do |o|
      o.tags.each do |t|
        path = t.ancestry_path
        if list[path[0]].nil?
          list[path[0]] = {:count => 1, :sub => []}
        else
          list[path[0]][:count] += 1
        end
        list[path[0]][:sub] << path[1]
      end
    end
    ret = "<ul class=\"category-side-bar\">"

    list = list.sort {|a,b| b[1][:count] <=> a[1][:count] }
    count = 0
    list.each do |cat|
      b = Hash.new(0)
      cat[1][:sub].each do |v|
        b[v] += 1
      end
      style = count > threshold ? "hidden-cat" : ""
      ret << "<li class=\"title #{style}\"><a href=\"#{category_path(cat[0], obj)}\">#{cat[0]} (#{cat[1][:sub].count})</a><ul>"
      b = b.reject {|o| o.nil?}
      b.each do |k, v|
        ret << "<li><a href=\"#{category_path(k, obj)}\">#{k} (#{v})</a></li>\n"
      end
      ret << "</li></ul>"
      count += 1
    end
    ret += "</ul><a id=\"show-all-cats\">Show all categories in the area.</a>"
  end

  # This was originally to parse the rating JSON and send back a hash.
  # It should be refactored to return a full rating object.
  def rating_helper(rating)
    metrics = JSON.parse rating.review
    metrics.map! do |r|
      {:key => Rating.find(r["rating_id"]).text, :val => r["value"] }
    end
    { :name => rating.user.display_name, :time => rating.created_at.strftime("%I:%m%p on %B %d, '%C"), 
     :overall => rating.overall, :metrics => metrics, :comment => rating.comment, :photo => rating.photo, :rating => rating }
  end
  
  def color_rating(number)
    color = case number.round(0)
    when -5..0
      "poor"
    when 0..1
      "ok"
    when 1..5
      "great"
    else 
      "ok"
    end
      
    "<em class=\"rating-overall #{color}\">#{number.round(1)}</em> overall."
  end

  def display_if_present(obj, keys)
    keys.inject("") { |str, k| obj[k].present? ? str+to_pair(obj,k) : str }
  end
  
  def to_pair(o,k)
    if k.eql? :website
      t = link_to o[k], o[k]
    else
      t = o[k]
    end
    "<dt>#{k.to_s.capitalize}</dt>\n<dd>#{t}</dd>"
  end

  # return an image tag for the appropriate map icon.
  def icon_for(rating, type)
    unless %w(event leader place).include? type.downcase
      # catch unsupported type
      return ""
    end
    unless rating.abs <= 5
      # catch bad rating
      return ""
    end
    file = if rating.round.eql? 0
             "#{type}s-zero.png"
           elsif rating > 0
             "#{type}s-pos#{rating.round}.png"
           else
             "#{type}s-neg#{rating.abs.round}.png"
           end
    "<img src=\"/images/#{file}\" height=\"42\" width=\"42\" alt=\"#{rating}\" />"
  end
  
  def show_header(obj)
      "<div class=\"show-header\">
      	<h2 class=\"date-created\">#{obj.short_time}</h2>
      	<h2 class=\"show-name\">#{obj.title}</h2>
      	<br style=\"clear: both;\" />
      </div>"
  end
  
  def find_top_cities(list)
    ordered = Hash.new({:distance => 0, :count => 0})
    puts list.count
    list.each do |p|
      ordered["#{p.city}, #{get_state p}"][:count] += 1
      ordered["#{p.city}, #{get_state p}"][:distance] = p.distance
    end
    ordered.join
  end
  
  def get_state(obj)
    obj[/(\D+)/].split(',').last.strip
  end
  
  def category_path(cat, item)
    "/#{item.class.table_name}/categories/#{URI.escape(cat, "/?&")}"
  end
  
  def location_path(loc)
    "?location=#{loc}"
  end
  
  def set_all_index_vars
    @all_items = klass.near(@location[:ll], default_distance)
    @items = @all_items.page(params[:page]).per(10)
    @json = @all_items.to_gmaps4rails
    @state_items = klass.where(:state => @location[:state]).ordered_cities
    @nearbys = @all_items.ordered_cities.sort {|a,b| b.c <=> a.c}[0...5]
    @top_national = klass.top_national
  end
  
  def set_show_vars
    @item = klass.find(params[:id])
    @ratings = @item.ratings.map {|r| rating_helper r }
    @rating = @item.ratings.new
  end

  def set_popular_vars
    @all_items = klass.popular.near(@location[:ll], 15)
    @json = @all_items.to_gmaps4rails
    @items = @all_items.page(params[:page]).per(10)
    @heading = "Hall of Fame"
  end
  
  def set_unsafe_vars
    @all_items = klass.where("cached_rating <= -3.5").order("cached_rating ASC").near(@location[:ll], 15)
    @json = @all_items.to_gmaps4rails
    @items = @all_items.page(params[:page]).per(10)
    @heading = "Unsafe #{klass.name.pluralize}"
  end
  
  def set_category_vars(class_type)
    @categories = class_type.roots.collect do |r| 
      {
        name: r.name, 
        id: r.id,
        children: r.children.collect do |c| 
          {name: c.name, id:c.id, children:c.children.collect { |c3| {name: c3.name, id:c3.id } } }
        end
      }
    end.sort { |r1, r2| r1[:name] <=> r2[:name]}
  end
  
  def associated_tag(klass)
    case klass 
    when Place
     PlaceType
    when Leader
     LeaderType
    when Event
     EventType
    end
  end
  
  def report_post(post)
    "/report/#{post.class.name.downcase}/#{post.id}"
  end
end
