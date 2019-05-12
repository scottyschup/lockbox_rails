Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], controllers: {
    confirmations: 'users/confirmations',
    registrations: 'users/registrations'
  }
  as :user do
    get '/users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    patch '/users', to: 'devise/registrations#update', as: :user_registration
    put '/users', to: 'devise/registrations#update'
  end

  root to: 'dashboard#index'

  resources :lockbox_partners, only: [:new, :create, :show] do
    scope module: 'lockbox_partners' do
      resources :users, only: [:new, :create]
    end
  end
end
