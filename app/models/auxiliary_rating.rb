class AuxiliaryRating < ActiveRecord::Base
  belongs_to :user
  belongs_to :rating
  
  attr_accessible :for, :value, :linked_id
end
