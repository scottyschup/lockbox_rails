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
      resource :add_cash, only: [:new, :create], controller: 'add_cash'
      resource :reconciliation, only: [:new, :create], controller: 'reconciliation'
    end
  end
end
