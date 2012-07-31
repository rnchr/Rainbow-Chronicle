class ApplicationController < ActionController::Base
  include ApplicationHelper
  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end  
  protect_from_forgery
  
  before_filter :load_recent_news
  before_filter :load_leaderboard
  before_filter :load_location
  
  def load_recent_news
    @recent = News.recent
  end
  
  def load_leaderboard
    @rankings = Ranking.includes(:user).all        
  end
  
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
  
  def load_location
    if not params[:location].blank?
      result = Geocoder.search(params[:location])
      unless result.empty?
        @location = {
          :ll => [result.first.latitude, result.first.longitude],
          :state => result.first.province_code,
          :string => "#{result.first.city}, #{result.first.province_code}"
          }
         session[:location_lat] = result.first.latitude
         session[:location_lng] = result.first.longitude
         session[:location_state] = result.first.province_code
         session[:location_string] = "#{result.first.city}, #{result.first.province_code}"
        return
      end
    elsif not session[:location_lat].blank?
      @location = {
        :ll => [session[:location_lat], session[:location_lng]],
        :state => session[:location_state],
        :string => session[:location_string]
      }
      return
    end
    if user_signed_in? && !current_user.location.blank?
      @location = {
        :ll => [current_user.lat, current_user.lng],
        :state => get_state(current_user.location),
        :string => current_user.location
        }
    # Required for testing in a local environment. Sets location to Medford, MA
    elsif request.ip.eql? '127.0.0.1'
       @location = {
          :ll => [42.413454,-71.1088269],
          :state => 'MA',
          :string => "Medford, MA"
          }
    else
      if request.location.latitude.eql?("0") || request.location.latitude.eql?(0)
        redirect_to 'pages#locator'
      else
       @location = {
          :ll => [request.location.latitude, request.location.longitude],
          :state => request.location.state_code,
          :string => "#{request.location.city}, #{request.location.state_code}"
          }
      end
    end

  end

  def default_distance
    15
  end
  
  def verify_admin
    authenticate_user! and current_user.admin? 
  end
  
  def authenticate_and_check_permission
    authenticate_user!
    @item = klass.find(params[:id])
    unless current_user.admin? or current_user.eql? @item.user
      redirect_to @item, notice: "You don't have permission to modify this record."
    end
  end
  
end
