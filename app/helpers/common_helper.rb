module CommonHelper
  # include ActionView::Helpers::UrlHelper
  def aggregate!
    cached_rating = ratings.average(:overall).to_f
    update_attributes!({:cached_rating => cached_rating})
  end
  
  def zipcode
    address.slice(address.rindex(/\d{5}/),5)
  end
  
  def rating_string
    (cached_rating > 0 ? "+" : "") + "#{cached_rating.round(2)}"
  end
  
  def gmaps4rails_title
    title
  end
  
  def gmaps4rails_infowindow
      "<span style=\"font-weight:bold;\">#{title}</span>
      <br>#{address}<br>Rating: #{rating_string}<br>
      <a href=\"/#{self.class.name.pluralize.downcase}/#{id}\">View Listing</a>" 
  end
  
  # splits the address at the first comma
  def split_addr
    address.insert( address.index(',')+1, "<br />")
  end
  
  def short_time
    created_at.strftime("%b %d")
  end
  
  def rating_color
    if cached_rating.round > 0
      "rating-pos-#{cached_rating.round}"
    else
      "rating-neg-#{cached_rating.round.abs}"
    end
  end
  
  def rating_icon(type)
    if cached_rating.round.eql? 0
      "/images/#{type}s-zero.png"
    elsif cached_rating > 0
      "/images/#{type}s-pos#{cached_rating.round}.png"
    else
      "/images/#{type}s-neg#{cached_rating.abs.round}.png"
    end
  end
  
  def static_icon
    type = self.class.name.downcase
    if cached_rating.round.eql? 0
      "http://www.rainbowchronicle.com/wp-content/themes/rainbow/img/icons/#{type}s-zero.png"
    elsif cached_rating > 0
      "http://www.rainbowchronicle.com/wp-content/themes/rainbow/img/icons/#{type}s-pos#{cached_rating.round}.png"
    else
      "http://www.rainbowchronicle.com/wp-content/themes/rainbow/img/icons/#{type}s-neg#{cached_rating.abs.round}.png"
    end
  end
end