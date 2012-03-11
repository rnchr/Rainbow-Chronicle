class News < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  attr_accessible :title, :user_id, :views, :link, :body, :lock, :created_at, :photo, :id, :comment_count
  validates :title, :presence => true
  
  scope :latest, order("created_at DESC")
  scope :recent, latest.limit(5)
  scope :popular, order("views DESC")
  scope :controversial, where("comment_count >= 2").latest
  scope :last_founders_post, where(:founders_post => true).latest.limit(1)
  
  def short_time
    created_at.strftime("%b %d")
  end
  
  def posted
    created_at.strftime("%B %d, '%y")
  end
  
  def timestamp
    created_at.strftime("%b %d, %R%p")
  end
  
  def image
    photo ||= 'rc-news'
    "/images/#{photo}.png"
  end
end
