DistroaulasRails3::Application.routes.draw do
  devise_for :users, :path_prefix => 'd'
  resources :users do
    get 'reset_pass'
    put 'update_pass'
  end

  scope '/importer' do
    get '/' => 'importer#index', :as => 'importer_index'
    get '/space_types' => 'importer#space_types', :as => 'import_space_types'
    get '/spaces' => 'importer#spaces', :as => 'import_spaces'
    get '/plans' => 'importer#plans', :as => 'import_plans'
    get '/careers' => 'importer#careers', :as => 'import_careers'
    get '/matters' => 'importer#matters', :as => 'import_matters'

    get '/importer/result' => 'importer#result', :as => 'import_result'

    post '/space_types' => 'importer#upload_space_types', :as => 'importer_upload_space_types'
    post '/spaces' => 'importer#upload_spaces', :as => 'importer_upload_spaces'
    post '/plans' => 'importer#upload_plans', :as => 'importer_upload_plans'
    post '/careers' => 'importer#upload_careers', :as => 'importer_upload_careers'
    post '/matters' => 'importer#upload_matters', :as => 'importer_upload_matters'
  end

  resources :equipment, :only => [:index, :new, :create, :update, :destroy, :edit]

  resources :calendars

  resources :events
  match 'ajax_careers_by_plan/:id' => 'careers#ajax_careers_by_plan'
  match 'new_event' => 'application#new_event', :as => 'new_event_from_free_space'
  match 'events/tip_summary/:id' => 'events#tip_summary'

  resources :space_types, :only => [:index, :new, :create, :update, :destroy, :edit]

  resources :plans

  resources :matters
  match 'ajax_get_matters_by_career/:id' => 'matters#ajax_get_matters_by_career'

  resources :spaces
  match 'ajax_free_spaces' => 'spaces#ajax_free_spaces'

  resources :careers

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
  root :to => "application#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'

  # match '/statics(/:action)*' => "statics#action"
  match '/statics/about' => "statics#about"
  match '/statics/calendars' => "statics#calendars"
  match '/statics/events' => "statics#events"
  match '/statics/spaces' => "statics#spaces"
end
