Rails.application.routes.draw do
  root 'parlors#index'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' }
  resources(:users, only: [:index, :show]) do
    member do
      get :delete
    end
  end

  resources :parlors, only: [:index, :show, :new, :create]
end
