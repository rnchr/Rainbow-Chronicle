class PagesController < ApplicationController
  def rainbow_map
  end
  
  def search
    @query = params[:query]
    query = "%#{@query.gsub(/\s/,'%')}%"
    
    @places = Place.where("title like ? or description like ?", query, query)
    @events = Event.where("title like ? or description like ?", query, query)
    @leaders = Leader.where("title like ?", query)
    @news = News.where("title like ? or body like ?", query, query)
    
    @results = @news.count + @leaders.count + @places.count + @events.count
  end
  
  def search_helper
    redirect_to "/search/#{params[:query]}"
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