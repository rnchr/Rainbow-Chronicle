class EventRatingsController < ApplicationController
  include RatingsHelper
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    redirect_to event_path (params[:event_id])
  end
  
  def create
    @event = Event.find params[:event_id]
    
    if @event.users.include? current_user
      redirect_to @event, notice: "You've already rated this event! Please edit your existing rating instead."
      return
    end

    @rating = @event.ratings.new
    @rating.review, overall, count = parse_review params
    @rating.comment = params[:comment]
    @rating.user = current_user
    @rating.overall = if count > 0 then (overall.to_f/count) else 0 end
      
    if @rating.save
      @event.aggregate!
      redirect_to @event
    else
      redirect_to events_path, notice: "Unable to save your review."
    end
  end
  
  def edit
    
  end
  
  def destroy
    rating = EventRating.find(params[:rating_id])
    event = Event.find(params[:event_id])
    if current_user.admin? or rating.user.eql? current_user
      rating.destroy
      redirect_to events_path(event), notice: "Your rating has been deleted."
    else
      redirect_to events_path(event), notice: "You don't have permission to do that."
    end
  end
end