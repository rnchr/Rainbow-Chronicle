class LeaderRating < ActiveRecord::Base
  belongs_to :leader
  belongs_to :user
  belongs_to :rating
  
  def listing
    leader
  end
  
  scope :last5, order("created_at DESC").limit(5)
  
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment
end
