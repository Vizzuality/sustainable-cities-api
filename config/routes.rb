# frozen_string_literal: true
Rails.application.routes.draw do
  scope module: :v1, constraints: APIVersion.new(version: 1, current: true) do
    # Account
    post  '/login',                       to: 'sessions#create'
    post  '/register',                    to: 'registrations#create'
    post  '/reset-password',              to: 'passwords#create'
    post  '/users/password',              to: 'passwords#update_by_token'
    patch '/users/current-user/password', to: 'passwords#update'

    # Contact us
    post '/contact-us', to: 'contact_us#create'

    # Helper requests
    get '/users/current-user',  to: 'current_user#show'
    get '/study-cases',         to: 'projects#index',     study_cases: true
    get '/study-cases/:id',     to: 'projects#show'

    # Business Model
    post '/business-models', to: 'business_model_edits#create'
    patch '/business-models/:id', to: 'business_model_edits#update'
    delete '/business-models/:id', to: 'business_model_edits#destroy'
    get 'business-model-edits/:id', to: 'business_model_edits#show'
    get '/business-model-categories', to: 'private_categories#index'

    # Resources
    jsonapi_resources :users do; end
    jsonapi_resources :cities do; end
    jsonapi_resources :events do; end
    jsonapi_resources :blogs do; end
    jsonapi_resources :city_supports do; end
    jsonapi_resources :countries do; end
    jsonapi_resources :projects do; end
    jsonapi_resources :bmes, path: 'business-model-elements' do; end
    jsonapi_resources :categories do; end
    jsonapi_resources :impacts do; end
    jsonapi_resources :enablings do; end
    jsonapi_resources :comments, except: :show do; end
    jsonapi_resources :external_sources do; end
    jsonapi_resources :business_models, except: [:create, :update] do; end
    jsonapi_resources :contacts, except: [:delete, :update] do; end

    get '/csvs/projects', to: 'csvs#projects', defaults: { format: 'csv' }
    get '/csvs/bmes', to: 'csvs#bmes', defaults: { format: 'csv' }
  end
end
