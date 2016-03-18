Rails.application.routes.draw do
  


  devise_for :users
  apipie
  namespace :api do
      namespace :v1 do
        resources :products
        resources :categories
      end
  end
  resources :sizes
  resources :tax_rates
  resources :brands
  resources :brands
  resources :brands
  scope "suppliers/:supplier_id" do
    resources :registration_steps
  end

  resources :suppliers do
    resources :contacts
    resources :addresses
    resources :finances
  end
  
  resources :stock_levels, :only => [:index, :create, :destroy]
    
  get 'dashboard' => 'dashboard#index'

  resources :products do
    resources :variants
    resources :images, :only => [:create, :destroy]
  end

  resources :categories do
    resources :subcategories
  end

  #resources :images, :only => [:create, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  #root 'welcome#index'
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'

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
end
