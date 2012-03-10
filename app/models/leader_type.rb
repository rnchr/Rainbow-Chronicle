class LeaderType < Category
  has_many :leader_categories
  has_many :leaders, :through => :leader_categories
  
  def self.items
    leaders
  end
end