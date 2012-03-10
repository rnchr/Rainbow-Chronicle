#!/usr/bin/env ruby
require_relative './user'

module MigrationTasks
  def self.migrate!
    users = []; errors = []
    DB[:rb11_users].map do |user|
    	ru = RainbowUser.new(user)
    	unless User.exists? ru.id
      	u = User.new
      	u.id = ru.id
      	u.update_attributes ru.gen_user_hash
      end
      users << ru
      ru.events.each do |e|
         begin
           unless Event.exists? e[:post_ID]
             ev = Event.new
             ev.id = e[:post_ID]
             ev.update_attributes RainbowUser.gen_event_hash(e)
           end
         rescue Exception => ex  
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
      ru.places.each do |e|
        begin
           unless Place.exists? e[:post_ID]
              ev = Place.new
              ev.id = e[:post_ID]
              ev.update_attributes RainbowUser.gen_place_hash(e)
            end
         rescue Exception => ex
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
  
      ru.leaders.each do |e|
        begin
          unless Leader.exists? e[:post_ID]
             ev = Leader.new
             ev.id = e[:post_ID]
             ev.update_attributes RainbowUser.gen_leader_hash(e)
           end
         rescue Exception => ex  
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
  
      ru.news.each do |e|
        begin
           unless News.exists? e[:post_ID]
              ev = News.new
              ev.id = e[:post_ID]
              ev.update_attributes RainbowUser.gen_news_hash(e)
            end
         rescue Exception => ex
           puts ex.message  
           puts "Error on:"
           ap e
           errors << e
         end
      end
    end

    puts "THERE WERE #{errors.count} ERRORS" if errors.count
    File.open("errors.txt", "a") do |f|
      f << "Errors from #{DateTime.now}\n"
      f << errors.join("\n\n")
    end
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

  def self.return_category_type(post_id)
    t = DB[:rb11_posts][:ID => post_id]
    case t[:post_type]
    when 'places'
      return PlaceType
    when 'leaders'
      return LeaderType
    when 'events'
      return EventType
    end
  end
  
  def self.update_id(old_id, new_id, type)
    statement = "UPDATE #{type} SET id=#{new_id} WHERE id=#{old_id}"
    ActiveRecord::Base.connection.execute statement
  end
  
  def self.get_parent_cat(term_id)
    query = "SELECT t.term_id, t.name from rb11_term_taxonomy b \
          inner join rb11_terms t on b.parent=t.term_id where b.term_id=#{term_id}"
    r = DB[query].first

    query_parent = "SELECT parent from rb11_term_taxonomy where term_id=#{r[:term_id]}"
    parent = DB[query_parent].first
    [r[:name], r[:term_id], parent[:parent]]
  end
  
  def self.get_all_categories(post_id)
    query = "SELECT b.parent, t.term_id, t.name from rb11_term_relationships a \
    inner join rb11_term_taxonomy b using(term_taxonomy_id) \
    inner join rb11_terms t on b.term_id=t.term_id where a.object_id=#{post_id} and b.taxonomy like \"%cats\""
    
    # puts "#{post_id}: #{DB[:rb11_posts][:ID => post_id][:post_title]}"
    
    resp = DB[query]
    arr = []
    resp.each do |r|
      arr << [r[:name], r[:term_id], r[:parent]]
    end
    # puts "initial arr: #{arr.inspect}"
    unused = []
    paths = []
    
    # sometimes all levels are not present.. add them until they are
    unless arr.inject(0) {|s,v| v[2]==0 ? s+1 : s+0} != 0
      parents = []
      arr.each do |a|
        parents << get_parent_cat(a[1])
      end
      arr << parents.flatten
      # puts "added #{parents.count} parents"
    end
    arr.uniq!
    arr.collect do |p|
      if p.last == 0
    	  [arr.find_all {|i| i[2]==p[1]}.count, 1].max.times { paths << [p[0..1]] }
    	else
    		unused << p
    	end
    end
    
    # puts "unused: #{unused.inspect}"
    l = unused.length
    l.times do
    	paths.each do |p|
    		child = unused.select { |t| t.last == p.last.last }.first
    		if child
    			unused.delete child
    			p << child[0..1]
    		else
    		end
    	end
    end
    ret = []
    paths.each do |p|
    	ret <<	p.map! {|m| m[0] }
    end
    ret
  end
end