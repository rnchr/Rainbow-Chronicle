class RankingsController < ApplicationController
  http_basic_authenticate_with :name => "rcmafia", :password => "rainbowz"
  def index
    @leaders = User.order('stars_count DESC').limit(40)
  end
  
  def update
    i=1
    holder = []
    40.times do 
      unless params[i.to_s].nil?
        holder << params[i.to_s].to_i
      end
      i += 1
    end
    if holder.length < 1 || holder.length > 6
      session[:verify_leaderboard] = true
      @leaders = User.order('stars_count DESC').limit(40)
      render :index
    else
      Ranking.destroy_all
      i=1
      holder.each do |leader|
        noob = Ranking.new
        noob.place = i
        i += 1
        noob.user_id=leader
        noob.save
      end 
      redirect_to places_path 
    end    
  end  

end
