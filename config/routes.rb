# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    # Account
    post  '/login',                       to: 'sessions#create'
    post  '/register',                    to: 'registrations#create'
    post  '/reset-password',              to: 'passwords#create'
    post  '/users/password',              to: 'passwords#update_by_token'
    patch '/users/current-user/password', to: 'passwords#update'

    # Helper requests
    get '/users/current-user',  to: 'current_user#show'
    get '/study-cases',         to: 'projects#index',     study_cases: true
    get '/study-cases/:id',     to: 'projects#show'
    get '/business-models',     to: 'projects#index_all', business_models: true
    get '/business-models/:id', to: 'projects#show_project_and_bm'
    get '/projects',            to: 'projects#index_all'
    get '/projects/:id',        to: 'projects#show_project_and_bm'

    ## Categories
    get '/solution-categories',                   to: 'categories#index', category_type: 'Solution'
    get '/solution-categories/:id',               to: 'categories#show'
    get '/timing-categories',                     to: 'categories#index', category_type: 'Timing'
    get '/timing-categories/:id',                 to: 'categories#show'
    get '/business-model-element-categories',     to: 'categories#index', category_type: 'Bme'
    get '/business-model-element-categories/:id', to: 'categories#show'
    get '/impact-categories',                     to: 'categories#index', category_type: 'Impact'
    get '/impact-categories/:id',                 to: 'categories#show'
    get '/enabling-categories',                   to: 'categories#index', category_type: 'Enabling'
    get '/enabling-categories/:id',               to: 'categories#show'
    get '/categories',                            to: 'categories#index', category_type: 'All'
    get '/categories-tree',                       to: 'categories#index', category_type: 'Tree'

    # Custom endpoints
    get '/projects-by-solution/:category_id', to: 'projects#by_solution'

    # Resources
    resources :users
    resources :cities
    resources :countries
    resources :projects, except: [:index, :show]
    resources :bmes, path: 'business-model-elements'
    resources :categories, except: [:index]
    resources :impacts
    resources :enablings
    resources :comments, except: :show
    resources :external_sources
  end
end
