module CommonHelper
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
  
  def gmaps4rails_infowindow
      "<span style=\"font-weight:bold;\">#{title}</span><br>#{address}<br>Rating: #{rating_string}"
  end
  
  # splits the address at the first comma
  def split_addr
    address.insert( address.index(',')+1, "<br />")
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
end