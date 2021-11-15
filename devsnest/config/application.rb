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
require 'leaderboard'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Devsnest
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    Dotenv.load

    config.time_zone = 'Asia/Kolkata'
    config.active_record.default_timezone = :local
    config.active_job.queue_adapter = :sidekiq
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

    # options for redis
    REDIS_OPTIONS = {
      page_size: 20,
      reverse: false,
      member_key: :name,
      rank_key: :rank,
      score_key: :score,
      member_data_key: :member_data,
      member_data_namespace: 'member_data',
      global_member_data: false
    }.freeze

    JUDGEZERO_OPTIONS = {
      # C 
      "c" => {
        id: 50,
        memory_limit: '512000',
        time_limit: '2'
       },

     # C++
      "cpp" => {
        id: 54, 
        memory_limit: '512000',
        time_limit: '2'
       },

     # Java
      "java" => {
        id: 62,
        memory_limit: '512000',
        time_limit: '4'
       },

     # Javascript
     "javascript" => { 
        id: 63,
        memory_limit: '512000',
        time_limit: '10'
       },
     
     # Python 2
      "python" => { 
       id: 70,
       memory_limit: '512000',
       time_limit: '10'
       },
     
     # Python 3
      "python3" => { 
        id: 71,
        memory_limit: '512000',
        time_limit: '10'
       },

     # Typescript
      "typescript" => { 
        id: 74,
        memory_limit: '512000',
        time_limit: '10'
       }
      }.freeze
      
    end
end
