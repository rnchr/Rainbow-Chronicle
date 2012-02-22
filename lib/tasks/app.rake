namespace :app do
  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "Sorry, this task isn't safe for production!"
    end
  end
  
  desc "Open up Migration Database"
  task :open_db do
    DB_NAME = '634196_rc_wp'
    DB = Sequel.connect("mysql://localhost/#{DB_NAME}", :user => 'root',
    		    :password => ENV["sql_pass"])
    DB.convert_invalid_date_time = nil
  end
  
  desc "Seed some data for development"
  task :seed => [:environment, :open_db] do
    require_relative './parse_data'
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
end