Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env == "development"
    provider :facebook, '179464932182365', 'aaeb3eac7fd22b95540e74ee62a9ae9d'
  end  
end