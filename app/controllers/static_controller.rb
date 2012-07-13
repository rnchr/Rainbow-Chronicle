class StaticController < ApplicationController
  layout "home_layout"

  def home
    if current_user
      redirect_to places_path
    end
  end

end
