Rails.application.routes.draw do
  root 'parlors#index'
  devise_for :users
end
