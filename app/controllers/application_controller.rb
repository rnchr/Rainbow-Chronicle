class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  protect_from_forgery
  before_filter :load_recent_news
  before_filter :load_location
  def load_recent_news
    @recent = News.order("created_at DESC").limit(5)
  end
  
  def load_location
    # Required for testing in a local environment. Sets location to Medford, MA
    if request.ip.eql? '127.0.0.1'
      @location = [42.413454,-71.1088269]
      @city = "Medford, MA"
    else
      @location = [request.location.latitude, request.location.longitude]
      @city = "#{request.location.city}, #{request.location.state_code}"
    end
  end
end
