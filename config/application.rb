# frozen_string_literal: true
require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"
require 'carrierwave'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
GC::Profiler.enable
ActiveSupport::Deprecation.silenced = true

module SustainableCities
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('app', 'models', 'indexes')

    config.api_only = true

    config.generators do |g|
      g.template_engine nil
      g.test_framework :rspec,
                       fixtures: true,
                       routing_specs: true,
                       controller_specs: true,
                       request_specs: true
    end
  end
end
