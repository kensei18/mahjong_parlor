Rails.application.routes.draw do
  root 'parlors#index'
  resources :parlors, only: [:index, :show, :new, :create]
  resources :users
  devise_for :users
end
