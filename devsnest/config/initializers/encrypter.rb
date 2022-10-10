# frozen_string_literal: true

$cryptor = ActiveSupport::MessageEncryptor.new(ENV['SECRET_KEY_BASE']) if ENV['SECRET_KEY_BASE'].present?
