#!/usr/bin/env ruby
require_relative './user'

module MigrationTasks
  def self.migrate!
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
  end

  def self.convert_ratings
    # Typos in the original DB, we can fix "pubicly" after full migrate....
    goodPlace = "Good place of same-sex couples"
    goodPlaceRev = "Good place for same-sex couples"
    publicViews = "Publicy state views on LGBT issues"
    publicViewsRev = "Publicy stated views on LGBT issues"
    DB[:rb11_ratings].where(:rating_question => goodPlace).update(:rating_question => goodPlaceRev)
    DB[:rb11_ratings].where(:rating_question => publicViews).update(:rating_question => publicViewsRev)
    
    rated = DB[:rb11_ratings].distinct(:rating_postid)
    rated.map do |r|
      begin
        klass = find_rating_type r[:rating_postid]
        post = klass.find r[:rating_postid]
        ratings_for_post = build_ratings r[:rating_postid]
        ratings_for_post.map do |rating|
           new_rating = post.ratings.create! rating
        end
      rescue ActiveRecord::RecordNotFound
        puts $!
      rescue Exception => ex
        unless ex.message.eql? 'PNF'
          puts "ERROR"
          puts ex.message
          raise
        end
      end
    end
  end
  
  def self.build_ratings(post_id)
    fields = DB[:rb11_ratings].where(:rating_postid => post_id)
    # Skip anonymous reviews
    users = fields.distinct(:rating_userid).filter('rating_userid != 0')
    ratings = []
    users.map do |u|
      rating = {
        :ip_address => u[:rating_ip],
        :created_at => u[:rating_timestamp],
        :user_id => u[:rating_userid],
      }
      reviews = []
      
      all = ratings_for_by post_id, u[:rating_userid]
      questions = 0
      sum = 0
      all.each do |q|
        if q[:rating_question].eql? 'Comments'
          rating[:comment] = q[:rating_rating]
        else
          q_id = DB[:rb11_rating_question][:question => q[:rating_question]][:question_id]
          reviews << {:rating_id => q_id.to_i, :value => q[:rating_rating].to_i}
          questions += 1
          sum += q[:rating_rating].to_i
        end
      end
      rating[:overall] = (sum/(questions*1.0))
      rating[:review] = reviews.to_json
      ratings << rating
    end
    ratings
  end

  
  def self.ratings_for_by(post_id, user_id)
    DB[:rb11_ratings].filter("rating_postid=#{post_id} AND rating_userid=#{user_id}")
  end
  
  def self.find_rating_type(post_id)
    post = DB[:rb11_posts][:ID => post_id]
    unless post.nil?
      case post[:post_type]
      when 'places'
        return Place
      when 'leaders'
        return Leader
      when 'events'
        return Event
      else
        raise 'PNF'
      end
    end
    raise 'PNF'
  end
end