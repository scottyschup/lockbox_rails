Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  get 'support_requests/new', to: 'lockbox_partners/support_requests#new'

  root to: 'dashboard#index'

  resources :lockbox_partners, only: [:new, :create, :show] do
    scope module: 'lockbox_partners' do
      resources :users, only: [:new, :create]
      resources :support_requests, only: [:new, :create, :show]
      resource :add_cash, only: [:new, :create], controller: 'add_cash'
    end
  end
end
