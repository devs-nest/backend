# frozen_string_literal: true

module Api
  module V1
    class EventResource < JSONAPI::Resource
      attributes :event_type, :message, :bot_type, :bot_details
    end
  end
end
