namespace :app do
  task :ensure_development_environment => :environment do
    if Rails.env.production?
      raise "Sorry, this task isn't safe for production!"
    end
  end
  
  desc "Seed some data for development"
  task :seed => :environment do
    
  end
end