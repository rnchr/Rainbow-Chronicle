class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :news
  validates :body, :presence => true
  after_validation :update_parent_count
  
  def update_parent_count
    transaction do
      news.comment_count += 1
      news.save!
    end
  end
end
