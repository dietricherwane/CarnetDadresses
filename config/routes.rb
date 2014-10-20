CarnetDadresse::Application.routes.draw do
  root :to => redirect("/users/sign_in")
  
  #mount Ckeditor::Engine => '/ckeditor'
  resource :wysihat_files
  #get "home/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  devise_for :users, :controllers => {:registrations => "devise/registrations", :sessions => "devise/sessions", :passwords => "devise/passwords"}
  
  devise_scope :user do
  	get 'users/sign_up' => 'devise/registrations#new', :as => :admin_dashboard
  	get "admin/edit/:id" => "devise/registrations#edit_admin", as: :edit_admin
  	patch "admin/update/:id" => "devise/registrations#update_admin", as: :update_admin
  	post "admin/search" => "devise/registrations#search_admin", as: :search_admin
  	get "admin/disable/:id" => "devise/registrations#disable_user", as: :disable_admin
  	get "admin/enable/:id" => "devise/registrations#enable_user", as: :enable_admin
  	#get 'users' => 'devise/registrations#new'
  	#get "user/edit_profile/:id" => "devise/registrations#edit", :as => :edit_user_profile
  	#patch 'user/update_profile' => 'devise/registrations#update_profile', :as => :update_user_profile
  end 
  
  get "persons" => "adress_books#persons", as: :persons
  post "person/create" => "adress_books#create_person", as: :create_person
  post "person/search" => "adress_books#search_person", as: :search_person
  get "person/edit/:id" => "adress_books#edit_person", as: :edit_person
  post "person/update/:id" => "adress_books#update_person", as: :update_person
  get "person/disable/:id" => "adress_books#disable_person", as: :disable_person
  get "person/enable/:id" => "adress_books#enable_person", as: :enable_person
  get "person/complete_profile/:id" => "adress_books#complete_profile", as: :complete_person_profile
  post "person/formation/create" => "adress_books#create_formation", as: :create_person_formation
  get "person/formation/edit/:id" => "adress_books#edit_formation", as: :edit_person_formation
  get "person/formation/disable/:id" => "adress_books#disable_formation", as: :disable_person_formation
  get "person/formation/enable/:id" => "adress_books#enable_formation", as: :enable_person_formation
  post "person/formation/update/:id" => "adress_books#update_formation", as: :update_person_formation
  post "person/experience/create" => "adress_books#create_experience", as: :create_person_experience
  get "person/experience/edit/:id" => "adress_books#edit_experience", as: :edit_person_experience
  get "person/experience/disable/:id" => "adress_books#disable_experience", as: :disable_person_experience
  get "person/experience/enable/:id" => "adress_books#enable_experience", as: :enable_person_experience
  post "person/experience/update/:id" => "adress_books#update_experience", as: :update_person_experience
  
  get "holdings" => "holdings#index", as: :holdings
  post "holding/create" => "holdings#create", as: :create_holding
  post "holding/js_create" => "holdings#js_create", as: :js_create_holding
  get "holding/edit/:id" => "holdings#edit", as: :edit_holding
  post "holding/update/:id" => "holdings#update", as: :update_holding
  get "holding/disable/:id" => "holdings#disable_holding", as: :disable_holding
  get "holding/enable/:id" => "holdings#enable_holding", as: :enable_holding
  get "holding/companies/:id" => "holdings#companies", as: :holding_companies
  get "js_holdings" => "holdings#get_holdings"
  
  get "companies" => "companies#companies", as: :companies
  post "company/create" => "companies#create", as: :create_company
  post "company/js_create" => "companies#js_create", as: :js_create_company
  post "company/search" => "companies#search_company", as: :search_company
  get "company/edit/:id" => "companies#edit", as: :edit_company
  post "company/update/:id" => "companies#update", as: :update_company
  get "company/disable/:id" => "companies#disable_company", as: :disable_company
  get "company/enable/:id" => "companies#enable_company", as: :enable_company
  get "js_companies" => "companies#get_companies"
  
  get "adress_book/edit/:id" => "adress_books#edit", as: :edit_adress_book
  post "adress_book/update/:id" => "adress_book#update", as: :update_adress_book
  
  get "news_feeds" => "news_feeds#index", as: :news_feeds
  post "news_feed/create" => "news_feeds#create", as: :create_news_feed
  get "news_feed/edit/:id" => "news_feeds#edit", as: :edit_news_feed
  post "news_feed/update/:id" => "news_feeds#update", as: :update_news_feed
  get "news_feed/disable/:id" => "news_feeds#disable_news_feed", as: :disable_news_feed
  get "news_feed/enable/:id" => "news_feeds#enable_news_feed", as: :enable_news_feed
  
  get "sales_areas" => "sales_areas#index", as: :sales_areas
  post "sales_area/create" => "sales_areas#create", as: :create_sales_area
  get "sales_area/edit/:id" => "sales_areas#edit", as: :edit_sales_area
  post "sales_area/update/:id" => "sales_areas#update", as: :update_sales_area
  get "sales_area/disable/:id" => "sales_areas#disable_sales_area", as: :disable_sales_area
  get "sales_area/enable/:id" => "sales_areas#enable_sales_area", as: :enable_sales_area
  
  get "address_book_titles" => "address_book_titles#titles"
  
  get "help" => "helps#index", as: :help
  post "help/create" => "helps#create", as: :create_help
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
  get '*rogue_url', :to => 'errors#routing'
  post '*rogue_url', :to => 'errors#routing'
end
