class News < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  attr_accessible :title, :user_id, :views, :link, :body, :lock, :created_at, :photo, :id
  validates :title, :presence => true
  
  scope :latest, order("created_at DESC")
end
