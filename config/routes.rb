Rails.application.routes.draw do
  root 'confessions#index'
  
  resources :confessions, only: [:index, :create] do
    resources :reactions, only: [:create]
  end
end