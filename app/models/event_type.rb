class EventType < Category
  has_many :event_categories
  has_many :events, :through => :event_categories
  
  def self.items
    events
  end
end