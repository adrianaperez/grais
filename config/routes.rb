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
end
