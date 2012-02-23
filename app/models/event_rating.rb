class EventRating < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  belongs_to :rating
  validates :user_id, :presence => true
  
  def full_rating
    {:text => rating.text, :value => value}
  end
end
