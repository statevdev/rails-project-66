# frozen_string_literal: true

Rails.application.routes.draw do
  scope module: :web do
    root 'home#index'

    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'auth/destroy', to: 'auth#destroy', as: :sign_out

    scope module: :repositories do
      resources :repositories, only: %i[index show new create] do
        resources :checks, only: %i[show create]
      end
    end
  end
end
