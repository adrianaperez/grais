Rails.application.routes.draw do

  get 'courses', to: 'courses#index'

  get 'courses/show'

  post '/courses', to: 'courses#create'

  get 'courses/new'

  get 'courses/edit'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'app#start'
  get 'dashboard', to: 'dashboard#index'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  resources :users
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :password_resets, only: [:new, :create, :edit, :update]

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
  end
end