# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_HOST_SQ'], password: ENV['REDIS_PASSWORD_SQ'], db: ENV['REDIS_DB_SQ'], namespace: "sidekiq_#{Rails.env}" }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_HOST_SQ'], password: ENV['REDIS_PASSWORD_SQ'], db: ENV['REDIS_DB_SQ'], namespace: "sidekiq_#{Rails.env}" }
end

schedule_file = 'config/schedule.yml'
Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file) if File.exist?(schedule_file) && Sidekiq.server?
