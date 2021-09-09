# frozen_string_literal: true

module Api
  module V1
    class NotificationBotResource < JSONAPI::Resource
      attributes :id, :user_id, :bot_token, :message
    end
  end
end
