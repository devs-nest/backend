# frozen_string_literal: true

module Api
  module V1
    class NotificationResource < JSONAPI::Resource
      attributes :message, :is_sent, :date_to_be_sent
    end
  end
end
