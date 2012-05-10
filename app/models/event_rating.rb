class EventRating < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  
  validates :user_id, :presence => true
  
  scope :last5, order("created_at DESC").limit(5)
  
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment
  
  def full_rating
    {:text => rating.text, :value => value}
  end
  
  def listing
    event
  end
end
