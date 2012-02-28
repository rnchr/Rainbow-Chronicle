require_relative './parse_data'

namespace :app do
  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "Sorry, this task isn't safe for production!"
    end
  end
  
  desc "Open up Migration Database"
  task :open_db do
    DB_NAME = '634196_rc_wp'
    DB = Sequel.connect("mysql://localhost/#{DB_NAME}", :user => 'root', :password => ENV["sql_pass"])
    DB.convert_invalid_date_time = nil
    begin
      DB.test_connection
    rescue Sequel::DatabaseConnectionError
      puts "Couldn't connect to the legacy database."
      exit(1)
    end
  end
  
  namespace :migrate do 
    desc "Perform all migration tasks"
    task :all => [:environment, :open_db, :major_types, :prune_bad_addresses, :ratings_seed, :ratings, :update_cached_ratings, :categories, :comments] do
      puts "Migration successful!!"
    end
    
    desc "Seed some data for development"
    task :major_types => [:environment, :open_db] do
      MigrationTasks.migrate!
    end
  
    desc "Generate CSV of events"
    task :events_to_csv => :environment do
      Event.all.each do |e|
        puts "#{e.title},#{e.lat},#{e.lng},#{e.rating}"
      end
    end
  
    desc "Seed Rating Text table"
    task :ratings_seed => [:environment, :open_db] do
      DB[:rb11_rating_question].map do |row|
        rating = { :text => row[:question],
          :for => row[:post_type],
          :order => row[:question_order],
          :set => row[:is_corp]
          }
        Rating.create! rating
      end
    end

    desc "Migrate Ratings"
    task :ratings => [:environment, :open_db] do
      MigrationTasks.convert_ratings
    end
  
    desc "Update cached ratings"
    task :update_cached_ratings => [:environment] do
      [Event, Place, Leader].map do |k|
        puts "fixing #{k.name}" 
        k.all.map do |t| 
          begin
            t.aggregate!
          rescue
          
          end
        end
      end
    end
  
    desc "Prune locations that don't geocode"
    task :prune_bad_addresses => :environment do
      [Event, Place, Leader].map do |k|
        puts "fixing #{k.name}" 
        k.all.map do |t| 
          t.destroy if t.geocode.nil?
        end
      end
    end
  
    desc "Migrate all post categories"
    task :categories => [:environment, :open_db] do
      [Place, Event, Leader].each do |klass|
        klass.all.map do |t|
          puts t.title
          MigrationTasks.get_all_categories(t.id).each do |cat|
            t.tags << MigrationTasks.return_category_type(t.id).find_or_create_by_path(cat)
          end
        end
      end
    end
  
    desc "Copy comments over"
    task :comments => [:environment, :open_db] do
      comments = DB[:rb11_comments].where(:comment_approved => 1)
      num = 0
      comments.each do |c|
        if c[:user_id] != 0
          comment = News.find(c[:comment_post_ID]).comments.new
          comment.user = User.find(c[:user_id])
          comment.body = c[:comment_content]
          comment.ip_address = c[:comment_author_IP]
          comment.created_at = c[:comment_date]
          comment.user_agent = c[:comment_agent]
          num += 1 if comment.save
        end
      end
      puts "#{num} comments migrated!"
    end
    
    desc "Recalculate comment counts"
    task :comment_counts => [:environment, :open_db] do
      News.all.map {|n| n.update_attributes!({:comment_count => n.comments.count})}
    end
  end
  namespace :out do
    desc "Output all models to CSV"
    task :csv => :environment do
      file = open "all.csv", 'w'
      [Event, Place, Leader].map do |k|
        k.all.map do |t|
          begin
            zip = t.zipcode
            file.write "\"#{t.title}\",#{t.lat.round(5)},#{t.lng.round(5)},#{zip},#{t.cached_rating},#{k.name}\n"
          rescue
            # Being sloppy because I am lazy
          end
        end
      end
      file.close
    end
  end
end