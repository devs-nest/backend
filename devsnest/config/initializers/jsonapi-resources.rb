# frozen_string_literal: true

JSONAPI.configure do |config|
  config.json_key_format = :underscored_key

  config.default_paginator = :paged
end
