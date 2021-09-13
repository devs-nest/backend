# frozen_string_literal: true

module Api
  module V1
    class BotResource < JSONAPI::Resource
      attributes :id, :bot_token
    end
  end
end
