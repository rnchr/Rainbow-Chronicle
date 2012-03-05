require 'closure_tree'
class Category < ActiveRecord::Base
  acts_as_tree
end
