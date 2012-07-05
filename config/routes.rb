RcRails::Application.routes.draw do
  
  get "authentications/index"

  get "authentications/create"

  get "authentications/destroy"

  match 'pages/:action', :controller => 'pages'
  match '/map'  => 'pages#map'
  match 'home' => 'static#home'
  match 'hometwo' => 'static#hometwo'
  
  devise_for :users, :controllers => {:registrations => 'registrations'}
  match '/auth/:provider/callback' => 'authentications#create'
  
  root :to => 'places#index'
  
  match '/search/:query' => 'pages#search'
  match '/search' => 'pages#search', :as => 'search'
  
  
  delete '/users/:id' => 'users#destroy', :as => 'destroy_user'
  match '/admin/users/:id/make_admin' => 'users#make_admin', :as => 'make_admin'
  post '/categories' => 'categories#create', :as => 'create_category'
  
  get '/report/:type/:id' => 'reports#new'
  post '/report/:type/:id' => 'reports#create'
  delete '/report/:id' => 'reports#destroy'

  match '/admin' => 'admin#index', :as => 'admin'
  match '/admin/:action', :controller => 'admin'

  get '/users/:id' => 'users#show', :as => 'user'

  resources :news do
    collection do
      get 'popular'
      get 'controversial'
    end
    resources :comments do
      match 'report' => 'comments#report'
    end
  end
  
  resources :events do
    collection do
      get 'popular'
      get 'unsafe'
    end
    resources :event_ratings
  end

  resources :leaders do
    collection do
      get 'popular'
      get 'unsafe'
    end
    resources :leader_ratings
  end

  match '/:type/categories/:category' => 'categories#show'

  resources :places do
    collection do
      get 'popular'
      get 'unsafe'
    end
    resources :place_ratings
  end

end
