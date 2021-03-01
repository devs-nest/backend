# frozen_string_literal: true

require_relative 'boot'
require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Devsnest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    Dotenv.load

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    Sentry.init do |config|
      config.dsn = ENV['SENTRY_DSN']
      config.breadcrumbs_logger = [:active_support_logger]

      # To activate performance monitoring, set one of these options.
      # We recommend adjusting the value in production:
      config.traces_sample_rate = 0.5
      # or
      config.traces_sampler = lambda do |_context|
        true
      end
    end

    # config.session_store :cookie_store, key: '_interslice_session', domain: :all, tld_length: 2, httponly: false
    # config.middleware.use ActionDispatch::Cookies # Required for all session management
    # config.middleware.use ActionDispatch::Session::CookieStore, config.session_options
    # Rails.application.config.session_store :disabled
    # config.middleware.delete ActionDispatch::Session::CookieStore
  end
end
