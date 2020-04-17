Rails.application.routes.draw do
  root 'parlors#index'

  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout' },
                     controllers: { registrations: 'users/registrations' }

  resources(:users, only: [:index, :show]) do
    member do
      get :delete
    end
  end

  resources(:parlors, only: [:index, :create, :new, :show, :update, :destroy]) do
    resources(:reviews, shallow: true, only: [:create, :new, :edit, :update, :destroy]) do
      resources :comments, shallow: true, only: [:create, :destroy]
    end
  end
end
