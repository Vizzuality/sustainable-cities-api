# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'pg',    '~> 0.18'
gem 'rails', '~> 5.1.0.rc1'

# API
gem 'active_model_serializers', '~> 0.10.4'
gem 'json-schema'
gem 'oj'
gem 'oj_mimic_json'
gem 'typhoeus', require: false

# Data
gem 'activerecord-import'
gem 'active_hash'
gem 'cancancan'
gem 'seed-fu'

# Auth and Omniauth
gem 'bcrypt'
gem 'jwt'

# Uploads
gem 'carrierwave', '~> 1.0'
gem 'mini_magick'

# Templating
gem 'slim-rails'
gem 'will_paginate'

# Messages
gem 'whenever', require: false

group :development, :test do
  gem 'byebug',                    platform: :mri
  gem 'faker'
  gem 'rubocop',                   require: false
  gem 'webmock'
end

group :development do
  gem 'annotate'
  gem 'brakeman',                  require: false
  gem 'capistrano',                '~> 3.6'
  gem 'capistrano-bundler'
  gem 'capistrano-env-config'
  gem 'capistrano-passenger'
  gem 'capistrano-postgresql'
  gem 'capistrano-rails',          '~> 1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-secrets-yml'
  gem 'listen',                    '~> 3.0.5'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen',     '~> 2.0.0'
end

group :test do
  gem 'bullet'
  gem 'codeclimate-test-reporter', '~> 1.0.0'
  gem 'database_cleaner'
  gem 'email_spec'
  gem 'factory_girl_rails'
  gem 'rspec-activejob'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'timecop'
end

# Server
gem 'dotenv-rails'
gem 'newrelic_rpm'
gem 'puma'
gem 'rack-cors'
gem 'rails_12factor',              group: :production
gem 'tzinfo-data'
