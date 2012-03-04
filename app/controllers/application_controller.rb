class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  protect_from_forgery
  before_filter :load_recent_news
  def load_recent_news
    @recent = News.order("created_at DESC").limit(5)
  end
end
