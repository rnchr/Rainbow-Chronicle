module ApplicationHelper
  def display_categories(objects)
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
    list[0..5].each do |cat|
      b = Hash.new(0)
      cat[1][:sub].each do |v|
        b[v] += 1
      end
      ret << "<li class=\"title\"><a>#{cat[0]} (#{cat[1][:sub].count})</a></li><ul>"
      b = b.reject {|o| o.nil?}
      b.each do |k, v|
        ret << "<li><a><i class=\"icon-chevron-right hover-image\"></i>#{k} (#{v})</a></li>\n"
      end
      ret << "</ul>"
    end
    ret += "</ul>"
  end

  def rating_helper(rating)
    metrics = JSON.parse rating.review
    metrics.map! do |r|
      {:key => Rating.find(r["rating_id"]).text, :val => r["value"] }
    end
    { :name => rating.user.display_name, :time => rating.created_at.strftime("%I:%m%p on %B %d, '%C"), 
     :overall => rating.overall, :metrics => metrics, :comment => rating.comment }
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
  
  
end
