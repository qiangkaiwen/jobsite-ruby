Rails.application.routes.draw do
  # get 'chart/index'
  #
  # get 'chart/show'
  resources :chart
  resources :categories
  resources :states
  resources :jobs do
    collection do
      get :create_new_job
    end
    member do
      get :search
      get :search_by_category
      get :search_by_state
    end
  end

  resources :hires do
    collection do
      get :new_invitation
    end
    member do
      get :invitation
      get :hire
      get :suspend
    end
  end

  resources :chats do
    collection do
      get :kick_out
      get :msg
      get :filter_by_user
      get :bid_by_user
      get :check_kicked
    end
  end

  resources :rooms do
    collection do
      post :msg
    end
    member do
      get :enterRoom
      get :search_by_category
    end
  end 
  resources :users do
    collection do
      post :login
      get :management
      get :exchange_used
    end
  end
  root 'jobs#index'
  # root to:redirect('/index.html');

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
end
