# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    # Account
    post '/login',    to: 'sessions#create'
    post '/register', to: 'registrations#create'

    # Helper requests
    get '/users/current-user',  to: 'current_user#show'
    get '/study-cases',         to: 'projects#index',     study_cases: true
    get '/study-cases/:id',     to: 'projects#show'
    get '/business-models',     to: 'projects#index_all', business_models: true
    get '/business-models/:id', to: 'projects#show_project_and_bm'
    get '/projects',            to: 'projects#index_all'
    get '/projects/:id',        to: 'projects#show_project_and_bm'

    # Resources
    resources :users
    resources :cities
    resources :countries
    resources :projects, except: [:index, :show]
  end
end
