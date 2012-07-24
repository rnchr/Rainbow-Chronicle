class StaticController < ApplicationController
  layout "home_layout", :only => :home

  def home
    if current_user
      redirect_to places_path
    end
  end
  
  def hiring
  end

end
