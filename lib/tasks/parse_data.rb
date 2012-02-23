#!/usr/bin/env ruby
require_relative './user'

module MigrationTasks
  def MigrationTasks.migrate!
    users = []; errors = []
    DB[:rb11_users].map do |user|
    	ru = RainbowUser.new(user)
      User.create!(ru.gen_user_hash) unless User.exists? ru.id
      # puts "added #{ru.display_name}"
      users << ru
      ru.events.each do |e|
         begin
           Event.create!(RainbowUser.gen_event_hash(e)) unless Event.exists? e[:post_ID]
         rescue Exception => ex  
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
      ru.places.each do |e|
        begin
           Place.create!(RainbowUser.gen_place_hash(e)) unless Place.exists? e[:post_ID]
         rescue Exception => ex
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
  
      ru.leaders.each do |e|
        begin
           Leader.create!(RainbowUser.gen_leader_hash(e)) unless Leader.exists? e[:post_ID]
         rescue Exception => ex  
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
  
      ru.news.each do |e|
        begin
           News.create!(RainbowUser.gen_news_hash(e)) unless News.exists? e[:post_ID]
         rescue Exception => ex
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
    end

    puts "THERE WERE #{errors.count} ERRORS" if errors.count

    users.map do |u|
      # add ratings and comments
    end
  end
end