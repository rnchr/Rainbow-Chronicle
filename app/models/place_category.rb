class PlaceCategory < ActiveRecord::Base
  belongs_to :place
  belongs_to :place_type
end