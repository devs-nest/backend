# frozen_string_literal: true

Rails.configuration.customerio = {
  site_id: ENV['CIO_SITE_ID'],
  api_key: ENV['CIO_API_KEY']
}

$customerio = Customerio::Client.new(Rails.configuration.customerio[:site_id], Rails.configuration.customerio[:api_key])
