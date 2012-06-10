class Title < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  
  def assign_title(place)
    if place == 1
      self.name = "Marshal"
      self.save
    elsif place == 2
      self.name = "Sheriff"
      self.save
    elsif place == 3
      self.name = "Deputy"
      self.save
    end
  end
  
end
