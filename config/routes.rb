Rails.application.routes.draw do
  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations'
  }

  root to: 'dashboard#index'
  get 'lockbox_partners', to: 'dashboard#index'

  match 'support_requests/new', to: 'lockbox_partners/support_requests#new', via: [:get]
  resource :support_requests, only: [:create]

  resources :lockbox_partners, only: [:new, :create, :show] do
    scope module: 'lockbox_partners' do
      resources :users, only: [:new, :create]
      resources :support_requests, only: [:new, :create, :show]
      resource :add_cash, only: [:new, :create], controller: 'add_cash'
    end
  end
end
