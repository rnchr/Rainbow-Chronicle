class AdminController < ApplicationController
  before_filter :verify_admin

  def index
    @count = {
      leader: Leader.count,
      leader_ratings: LeaderRating.count,
      place: Place.count,
      place_ratings: PlaceRating.count,
      event: Event.count,
      event_ratings: EventRating.count,
      user: User.count,
      news: News.count,
      comment: Comment.count,
      reports: Report.count
    }
  end
  
  def users
    @users = User.order("created_at DESC").page(params[:page]).per(40)
  end
  
  def reports
    @reports = Report.order("created_at ASC").page(params[:page]).per(40)
    @orig_posts = @reports.collect do |post|
      begin
        [class_for(post.post_type).find(post.item_id), post]
      rescue ActiveRecord::RecordNotFound
        post.destroy
        nil
      end
    end.compact
  end
  
  def events
    @events = Event.order("created_at DESC").page(params[:page]).per(40)
  end
  
  def places
    @places = Place.order("created_at DESC").page(params[:page]).per(40)
  end
  
  def leaders
    @leaders = Leader.order("created_at DESC").page(params[:page]).per(40)
  end
  
  def event_categories
    @type = "events"
    @categories = EventType.leaves
    @cat = EventType.new
    render 'new_category'
  end
  
  def place_categories
    @type = "places"
    @categories = PlaceType.leaves
    @cat = PlaceType.new
    render 'new_category'
  end
  
  def leader_categories
    @type = "leaders"
    @categories = LeaderType.leaves
    @cat = LeaderType.new
    render 'new_category'
  end
  
  def news
    @news = News.order("created_at DESC").page(params[:page]).per(40)
  end
  
  def all_ratings
  end
  
  private
  def class_for(type)
    {leader:Leader,place:Place,event:Event,comment:Comment}[type.to_sym]
  end
end