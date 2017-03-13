Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  get 'change_locale/:locale' => 'application#change_locale', as: :change_locale
  # get 'ratings/:id' => 'ratings#sorting', as: :ratings_sort
  get 'restaurants/search' => 'restaurants#search', as: :restaurant_search
  get 'restaurants/listing' => 'restaurants#listing', as: :restaurant_listing
  get 'owner/restaurants' => 'users#restaurants', as: :users_restaurant
  get 'owner/restaurants/new' => 'restaurants#owner_new', as: :owner_resto_new
  get 'owner/restaurants/:id' => 'restaurants#owner_edit', as: :owner_resto_edit
  patch 'owner/restaurants/:id' => 'restaurants#owner_patch', as: :owner_resto_patch
  get 'owner/notifications' => 'notifications#index', as: :notifications
  delete 'owner/notifications/:id' => 'notifications#destroy', as: :delete_notification
  get 'restaurants/reject/:id' => 'restaurants#reject', as: :restaurant_reject
  post 'restaurants/ratings/more/:id' => 'ratings#show_more', as: :show_more_rating
  post 'restaurants/ratings/:id' => 'ratings#more_reviews', as: :show_more_reviews
  post 'restaurants/post/more/:id' => 'posts#show_more', as: :show_more_post
  post 'restaurants/pictures/more/:id' => 'pictures#show_more', as: :show_more_picture

  get 'home/about' => 'home#about', as: :about_page
  get 'home/contact' => 'home#contact', as: :contact_page
  get 'home/index'
  get '/cuisines' => 'cuisines#index', as: :cuisines
  devise_for :users, :controllers => { :registrations => :registrations, :omniauth_callbacks => :omniauth_callbacks }
  devise_scope :user do
    delete '/admin/logout', :to => 'active_admin/devise/sessions#destroy', as: :admin_logout
  end
  resources :restaurants, except: :index
  resources :foods
  resources :pictures
  resources :ratings
  resources :schedules
  resources :users, except: :index
  resources :posts
  resources :replies

  post 'likes' => 'likes#create', as: :likes
  delete 'likes' => 'likes#destroy', as: :delete_like


  get 'users/:id' => 'users#show', as: :user_profile

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  get '*path' => redirect('/')
  root 'home#index', as: 'home'
end
