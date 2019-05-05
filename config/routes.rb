Rails.application.routes.draw do
  devise_for :users

  root to: 'dashboard#index'

  resources :lockbox_partners, only: [:new, :create, :show]
end
