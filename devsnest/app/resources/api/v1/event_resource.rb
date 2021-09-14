# frozen_string_literal: true

module Api
  module V1
    class EventResource < JSONAPI::Resource
      attributes :name, :message, :bot_type
    end
  end
end
