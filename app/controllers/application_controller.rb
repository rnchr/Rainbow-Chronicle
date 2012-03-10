class ApplicationController < ActionController::Base
  include ApplicationHelper
  
  protect_from_forgery
  
  before_filter :load_recent_news
  before_filter :load_location
  
  def load_recent_news
    @recent = News.recent
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def load_location

    if not params[:location].blank?
      result = Geocoder.search(params[:location])
      unless result.empty?
        @location = [result.first.latitude, result.first.longitude]
        @city = "#{result.first.city}, #{result.first.province_code}"
        @state = result.first.province_code
        return
      end
    end
    
    if user_signed_in? && !current_user.location.blank?
      @location = [current_user.lat, current_user.lng]
      @city = current_user.location
    # Required for testing in a local environment. Sets location to Medford, MA
    elsif request.ip.eql? '127.0.0.1'
      @location = [42.413454,-71.1088269]
      @city = "Medford, MA"
      @state = 'MA'
    else
      @location = [request.location.latitude, request.location.longitude]
      @city = "#{request.location.city}, #{request.location.state_code}"
      @state = request.location.state_code
    end

  end
end
