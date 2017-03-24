# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    # Account
    post '/login', to: 'sessions#create'

    # Helper requests
    get '/users/current-user', to: 'current_user#show'

    # Resources
    resources :users
    resources :cities
    resources :countries
  end
end
