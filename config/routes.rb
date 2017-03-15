# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, path: 'account',
                     path_names: {
                       sign_in: 'login', sign_out: 'logout',
                       password: 'secret', sign_up: 'register'
                     },
                     controllers: {
                       sessions: 'users/sessions',
                       registrations: 'users/registrations',
                       passwords: 'users/passwords'
                     }

  scope :account do
    devise_scope :user do
      post 'register',  to: 'users/registrations#create', as: :register
      post 'password',  to: 'users/passwords#create',     as: :secret
      post 'edit',      to: 'users/registrations#edit',   as: :account_edit
    end
  end

  root to: 'home#index'
end
