class LeaderRating < ActiveRecord::Base
  belongs_to :leader
  belongs_to :user
  belongs_to :rating
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, 
                            :path => ":rails_root/public/system/leader_ratings/:id/:style/:filename",
                            :url => "/system/leader_ratings/:id/:style/:filename"
  
  def listing
    leader
  end
  
  scope :last5, order("created_at DESC").limit(5)
  
  attr_accessible :ip_address, :created_at, :user_id, :overall, :review, :comment, :photo
end
