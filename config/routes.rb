Rails.application.routes.draw do
  root 'parlors#index'
  resources :parlors, only: [:index, :new, :create]

  devise_for :users
end
