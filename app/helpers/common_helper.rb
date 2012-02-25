module CommonHelper
  def aggregate!
    cached_rating = ratings.average(:overall).to_f
    update_attributes!({:cached_rating => cached_rating})
  end
  
  def zipcode
    address.slice(address.rindex(/\d{5}/),5)
  end
end