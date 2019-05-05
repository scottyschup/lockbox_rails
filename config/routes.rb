Rails.application.routes.draw do
  devise_for :users

  root to: 'dashboard#index'

  resources :lockbox_partners, only: [:new, :create, :show] do
    scope module: 'lockbox_partners' do
      resources :users, only: [:new, :create]
    end
  end
end
