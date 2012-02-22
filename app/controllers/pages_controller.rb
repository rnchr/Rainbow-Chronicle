class PagesController < ApplicationController
  respond_to :html
  def rainbow_map
    ActiveRecord::Base.connection.execute(
    "select title, lat, lng, (select 'event') as type from events UNION "+
    "select title, lat, lng, (select 'place') as type from places UNION "+
    "select title, lat, lng, (select 'leader') as type from leaders;") do |result|
      @json = result.to_gmaps4rails
    end
    # @json = Event.all.to_gmaps4rails
    render 'map.html'
  end
end