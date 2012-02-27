class LeaderCategory < ActiveRecord::Base
  belongs_to :leader
  belongs_to :leader_type
end