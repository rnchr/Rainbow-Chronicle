RcRails::Application.routes.draw do
  
  match 'pages/:action', :controller => 'pages'

  devise_for :users

  root :to => 'places#index'
  match '/map'  => 'pages#map'
  
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

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
