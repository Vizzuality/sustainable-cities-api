# frozen_string_literal: true
require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"
require 'carrierwave'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
GC::Profiler.enable

module SustainableCities
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework  :rspec
      g.template_engine :slim
      g.view_specs      false
      g.helper_specs    false
      g.factory_girl    true
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end
  end
end
