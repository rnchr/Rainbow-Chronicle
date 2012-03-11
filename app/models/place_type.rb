class PlaceType < Category
  has_many :place_categories
  has_many :places, :through => :place_categories
  
  def items; places; end
end