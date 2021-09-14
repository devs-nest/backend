# frozen_string_literal: true

module Api
  module V1
    class NotificationBotResource < JSONAPI::Resource
      attributes :id, :bot_token
    end
  end
end
