Rails.application.routes.draw do
  root 'home#hello'
  devise_for :users
end
