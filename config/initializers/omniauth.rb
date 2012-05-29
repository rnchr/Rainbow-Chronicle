Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.env == "production"
    provider :facebook, '312005155550455', 'a9d9c3f0f5c52dbcacd8b1fad7465973'
  end  

  if Rails.env == "development"
    provider :facebook, '179464932182365', 'aaeb3eac7fd22b95540e74ee62a9ae9d'
  end  
end