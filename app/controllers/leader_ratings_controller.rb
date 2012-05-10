class LeaderRatingsController < ApplicationController
  include RatingsHelper
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    redirect_to leader_path (params[:leader_id])
  end
  
  def create
    @leader = Leader.find params[:leader_id]
    
    if @leader.users.include? current_user
      redirect_to @leader, notice: "You've already rated this leader! Please edit your existing rating instead."
      return
    end

    @rating = @leader.ratings.new
    @rating.review, overall, count = parse_review params
    @rating.comment = params[:comment]
    @rating.user = current_user
    @rating.overall = if count > 0 then (overall.to_f/count) else 0 end
    @rating.photo.assign(params[:leader_rating][:photo])

    if @rating.save
      @leader.aggregate!
      redirect_to @leader
    else
      redirect_to leaders_path, notice: "Unable to save your review."
    end
  end
  
  def edit
    
  end
  
  def destroy
    rating = LeaderRating.find(params[:rating_id])
    leader = Leader.find(params[:leader_id])
    if current_user.admin? or rating.user.eql? current_user
      rating.destroy
      redirect_to leaders_path(leader), notice: "Your rating has been deleted."
    else
      redirect_to leaders_path(leader), notice: "You don't have permission to do that."
    end
  end
end