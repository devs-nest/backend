# frozen_string_literal: true

JSONAPI.configure do |config|
  config.json_key_format = :underscored_key
  config.resource_cache = Rails.cache

  config.maximum_page_size = 50
end
