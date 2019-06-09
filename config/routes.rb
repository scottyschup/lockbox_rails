Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  resources :support_requests, only: [:new, :create, :show]

  root to: 'dashboard#index'

  resources :lockbox_partners, only: [:new, :create, :show] do
    scope module: 'lockbox_partners' do
      resources :users, only: [:new, :create]
    end
  end
end
