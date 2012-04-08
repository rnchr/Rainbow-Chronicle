class PagesController < ApplicationController
  def map
    @all = JSON.parse Place.all.to_gmaps4rails
    @all += JSON.parse Event.all.to_gmaps4rails
    @all += JSON.parse Leader.all.to_gmaps4rails
    @json = @all.to_json
  end
  
  def search
    @query = params[:query]
    unless @query.nil?
      query = "%#{@query.gsub(/\s/,'%')}%"
      @places = Place.where("title like ? or description like ?", query, query)
      @events = Event.where("title like ? or description like ?", query, query)
      @leaders = Leader.where("title like ?", query)
      @news = News.where("title like ? or body like ?", query, query)
      @results = @news.count + @leaders.count + @places.count + @events.count
    end
  end
  
  def search_helper
    redirect_to "/search/#{params[:query]}"
  end
  
  def test
  end
  
  def locator
    unless params[:addr_string].blank? && params[:set_lat].blank? &&
              params[:set_lng].blank? && params[:state].blank?
      session[:location_lat] = params[:set_lat].to_f
      session[:location_lng] = params[:set_lng].to_f
      session[:location_state] = params[:state]
      session[:location_string] = params[:addr_string]
    end
  end
  
  def categories
   
  end
  
  def tos
  end
  
  def about
  end
  
  def faq
  end
  
  def contact
  end
  
  def advertising
  end
  
  def donate
  end
  
  def privacy
  end
  
  def test
  end
end