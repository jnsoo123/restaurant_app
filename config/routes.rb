Rails.application.routes.draw do
  get 'change_locale/:locale' => 'application#change_locale', as: :change_locale
  get 'administrator' => 'administrator#index'
  # get 'ratings/:id' => 'ratings#sorting', as: :ratings_sort
  get 'restaurants/search' => 'restaurants#search', as: :restaurant_search
  get 'restaurants/listing' => 'restaurants#listing', as: :restaurant_listing
  get 'owner/restaurants' => 'users#restaurants', as: :users_restaurant
  get 'owner/restaurants/new' => 'restaurants#owner_new', as: :owner_resto_new
  get 'owner/restaurants/:id' => 'restaurants#owner_edit', as: :owner_resto_edit
  patch 'owner/restaurants/:id' => 'restaurants#owner_patch', as: :owner_resto_patch
  get 'restaurants/reject/:id' => 'restaurants#reject', as: :restaurant_reject
  
  get 'home/index'
  
  devise_for :users
  
  resources :restaurants 
  resources :cuisines
  resources :foods
  resources :pictures
  resources :ratings
  
  resources :users
  
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
  root 'home#index', as: 'home'
end
