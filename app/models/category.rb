require 'closure_tree'
class Category < ActiveRecord::Base
  acts_as_tree
  
  def self.related_to(cat, location)
    tags = where(:name => cat)
    return [] if tags.empty?
    tags.collect {|tag| tag.self_and_descendants.collect {|t| t.items.near(location) } }.flatten.uniq
  end 
end
