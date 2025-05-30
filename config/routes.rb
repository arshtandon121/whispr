Rails.application.routes.draw do
  root 'confessions#index'
  
  # Authentication routes
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  # Admin routes
  namespace :admin do
    resources :confessions, only: [:index, :destroy]
  end
  
  # Main app routes
  resources :confessions, only: [:index, :create] do
    member do
      get :check_reaction
    end
    resources :reactions, only: [:create]
  end
end