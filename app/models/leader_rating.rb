class LeaderRating < ActiveRecord::Base
  belongs_to :leader
  belongs_to :user
end
