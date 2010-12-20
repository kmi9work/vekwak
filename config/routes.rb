Vekwak::Application.routes.draw do
  resources :students
  #resources :topics   
#  resources :comments   
  resources :sections

  resource :session, :only => [:new, :create, :destroy]
  

  match 'signup' => 'students#new', :as => :signup

  match 'register' => 'students#create', :as => :register

  match 'login' => 'sessions#new', :as => :login

  match 'logout' => 'sessions#destroy', :as => :logout

  match '/activate/:activation_code' => 'students#activate', :as => :activate, :activation_code => nil
  
  match 'new_aul' => 'headman_aul#new', :as => :aul_new

  match 'list_aul' => 'headman_aul#list', :as => :aul_list
  
  match 'create_aul' => 'headman_aul#create', :as => :headman_aul_create

  match 'delete_comment/:id' => 'comments#destroy', :as => :delete_comment
  match 'new_comment' => 'comments#new', :as => :new_comment
  match 'create_comment' => 'comments#create', :as => :create_comment

  match 'delete_topic/:id' => 'topics#destroy', :as => :delete_topic
  match 'new_topic' => 'topics#new', :as => :new_topic
  match 'create_topic' => 'topics#create', :as => :create_topic
  match 'edit_topic' => 'topics#edit', :as => :edit_topic
  resources :topics

  root :to => "topics#index"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
