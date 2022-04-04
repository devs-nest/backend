# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# ActionMailer::Base.smtp_settings = {
#     :user_name => 'apikey', # This is the string literal 'apikey', NOT the ID of your API key
#     :password => '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', # This is the secret sendgrid API key which was issued during API key creation
#     :domain => 'yourdomain.com',
#     :address => 'smtp.sendgrid.net',
#     :port => 587,
#     :authentication => :plain,
#     :enable_starttls_auto => true
#   }
