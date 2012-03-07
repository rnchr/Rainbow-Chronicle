class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  protect_from_forgery
  before_filter :load_recent_news
  def load_recent_news
    @recent = News.order("created_at DESC").limit(5)
  end
  
  def find_top_cities(list)
    ordered = Hash.new({:distance => 0, :count => 0})
    list.each do |p|
      ordered["#{p.city}, #{get_state p}"][:count] += 1
      ordered["#{p.city}, #{get_state p}"][:distance] = p.distance
    end
    ordered
  end
  
  def get_state(obj)
    obj.address[/(\D+)/].split(',').last.strip
  end
end
