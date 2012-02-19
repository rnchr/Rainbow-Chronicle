class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :news
  validates :body, :presence => true
end
