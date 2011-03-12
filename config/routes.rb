Vekwak::Application.routes.draw do

  resource :session, :only => [:new, :create, :destroy]
  match '/activate/:activation_code' => 'students#activate', :as => :activate, :activation_code => nil
  match 'signup' => 'students#new', :as => :signup
  match 'register' => 'students#create', :as => :register
  match 'login' => 'sessions#new', :as => :login
  match 'logout' => 'sessions#destroy', :as => :logout
  match 'chpass' => 'students#edit', :as => :chpass
  
  resources :students, :only => [:new, :create, :show, :edit, :update] 
  match 'student_info/:id(.:format)' => 'students#info', :as => :student_info
  match 'student_change_avatar/:id(.:format)' => 'students#change_avatar', :as => :student_change_avatar
  match 'posts/:post_id/plus(.:format)' => 'posts#plus', :as => :post_plus
  match 'posts/:post_id/minus(.:format)' => 'posts#minus', :as => :post_minus
  match 'posts/:post_id/raters(.:fomat)' => 'posts#raters', :as => :post_raters
  match 'comments/:comment_id/plus(.:format)' => 'comments#plus', :as => :comment_plus
  match 'comments/:comment_id/minus(.:format)' => 'comments#minus', :as => :comment_minus
  match 'comments/:comment_id/raters(.:fomat)' => 'comments#raters', :as => :comment_raters
  match 'posts/new_big(.:format)' => 'posts#new_big', :as => :new_big_post
  match 'comments/list(.:format)' => 'comments#list', :as => :comments_list
  match 'posts/preview' => 'posts#preview'
  resources :blinds
  resources :posts do
    resources :comments, :only => [:new, :create, :destroy]
  end
  resources :comments, :only => [:new, :create, :destroy] do
    resources :comments, :only => [:new, :create, :destroy]
  end
  resources :sections
  resources :headman_auls, :only => [:index, :new, :create]
  resources :messages, :only => [:index, :new, :create, :show]
  resources :news, :only => [:index, :new, :create]
  match 'days/new/:date(.:format)' => 'days#new', :as => :new_day
  match 'days/add/:id/:date(.:format)' => 'days#add', :as => :add_day
  resources :days, :except => [:new]
  match 'days/week' => 'days#week', :as => :week
  match 'next_week(.:format)' => 'days#next_week', :as => :next_week
  match 'prev_week(.:format)' => 'days#prev_week', :as => :prev_week
  resources :events, :only => [:destroy]

  root :to => "posts#index"

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
