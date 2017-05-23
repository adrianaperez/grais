Rails.application.routes.draw do

  #Rutas de prueba
  #get '/courses/:id/teams', to: 'teams#find_teams_by_course', as: 'teams_course'
  #get '/courses/all', to:'courses#all', as: 'all_courses'
  #resources :teams, :defaults => { :format => 'json' }, :except => [ :create,:update, :destroy, :edit, :index, :show, :new] do
    #collection do
      #post :create
    #end
  #end
  #post 'users/change_password/:id', to: 'users#change_password', as: 'change_password_users'
  #resources :users do
    #member do
      #post 'change_password'
    #end
  #end

  post 'commitment_prototypes', to: 'commitments_prototypes#create', as: 'commitment_prototypes'
  post 'set_token', to: 'fcm_tokens#set_token', as: 'set_token'
  resources :posts do
    resources :comments
  end
  #resources :comments
  resources :courses do
   resources :posts
  end
  #resources :posts
  resources :tasks
  resources :commitments
  resources :prototypes
  resources :products
  resources :teams
  resources :courses
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'app#start'
  get 'dashboard', to: 'dashboard#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update] do
    collection do
      post :reset_user_password
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :users, :defaults => { :format => 'json' }, :except => [:create, :update, :destroy, :edit, :index, :show, :new] do
    collection do
      post :find
    end
    collection do
      post :create_user
    end
    collection do
      post :update_user
    end
    collection do
      post :all # TODO: Esto deberia ser un get pero hay otra ruta por defecto que toma el request si se hace get
    end
    collection do
      post :change_password
    end
  end

 #exeptuar aquellas acciones que no son para la app 
  resources :courses, :defaults => { :format => 'json' }, :except => [:create, :update, :destroy, :edit, :index, :show, :new, :delete] do
    collection do
      post :create_course
    end
    collection do
      post :update_course
    end
    collection do
      post :find_courses_by_user
    end
    collection do
      post :search_courses_by_string
    end
    collection do
      post :all #TODO: Esto deberia ser un get pero hay otra ruta por defecto que toma el request si se hace get
    end
    collection do
      post :add_member_to_course
    end
     collection do
      post :find_members_by_course
    end
     collection do
      post :request_course_access
    end
  end

  resources :teams, :defaults => { :format => 'json' }, :except => [:create, :update, :destroy, :edit, :index, :show, :new] do
    collection do
      post :create_team
    end
    collection do
      post :add_member_to_team
    end
    collection do
      post :delete_member
    end
    collection do
      post :find_teams_by_course
    end
    collection do
      post :find_members_by_team
    end
    collection do
      post :find_teams_by_user
    end
    collection do
      post :update_team
    end
    collection do
      post :request_team_access
    end
    collection do
      post :find_teams_by_prototype
    end
  end

  resources :products, :defaults => { :format => 'json' }, :except => [ :create,:update, :destroy, :edit, :index, :show, :new] do
    collection do
      post :find_products_by_course
    end
    collection do
      post :find_products_by_user
    end
    collection do
      post :find_products_by_team
    end
    collection do
      post :create_product
    end
    collection do
      post :update_product
    end
  end


  #exeptuar aquellas acciones que no son para la app 
  resources :commitments, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :find_by_user
    end
    collection do
      post :find_by_product
    end
    collection do
      post :find_by_team
    end
    collection do
      post :create_commitment
    end
    collection do
      post :update_commitment
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :tasks, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :find_by_user
    end
    collection do
      post :find_by_commitment
    end
    collection do
      post :create_task
    end
    collection do
      post :update_task
    end
    collection do
      post :find_user_task_by_product
    end
  end

   #exeptuar aquellas acciones que no son para la app 
  resources :prototypes, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :create_prototype
    end
    collection do
      post :update_prototype
    end
    collection do
      post :find_by_course
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :commitments_prototypes, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :create_commitment_prototypes
    end
    collection do
      post :update_commitment_prototypes
    end
    collection do
      post :find_by_prototype
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :tasks_abstracts, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :create_task_abstract
    end
    collection do
      post :update_task_abstract
    end
    collection do
      post :find_by_user
    end
    collection do
      post :find_by_task
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :commitment_abstracts, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :create_commitment_abstract
    end
    collection do
      post :update_commitment_abstract
    end
    collection do
      post :find_by_product
    end
    collection do
      post :find_by_commitment
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :product_reports, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :create_product_report
    end
    collection do
      post :update_product_report
    end
    collection do
      post :find_by_team
    end
    collection do
      post :find_by_product
    end
  end

  #exeptuar aquellas acciones que no son para la app 
  resources :notifications, :defaults => { :format => 'json' }, :except => [:create, :update] do
    collection do
      post :get_notifications
    end
    collection do
      post :set_viewed
    end
    collection do
      post :set_accepted
    end
  end
end