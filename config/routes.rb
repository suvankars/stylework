Rails.application.routes.draw do


  scope module: 'frontend' do
    resources :lists do
      get 'search_index', :on => :collection
    end
  end

  scope module: 'frontend' do
    resources :sellers, only: [:new, :create]
    resources :buyers, only: [:index, :show]
  end



  namespace :frontend do
    get 'home/index'
  end

  devise_for :users
  apipie
  namespace :api do
      namespace :v1 do
        resources :products
        resources :categories
      end
  end

  root 'frontend/home#index'

  get 'backend/welcome/index'

  scope '/admin', :module => 'backend' do

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
        post 'park_images', :on => :collection
        # collection do
        # post :schedule
        # put :save_scheduling
        #end
        resources :variants
        resources :images, :only => [:create, :destroy] do
          collection do
            get 'remove_all'
            #post 'park_images'
          end
        end

      end

      resources :categories do
        resources :subcategories
      end
    end
  #end


  scope module: 'common' do
    resources :images do
      post 'park_images', :on => :collection
    end
  end

  # The priority is based upon order of creation: first created -> highest priority.
  #root 'welcome#index'
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"


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
