# frozen_string_literal: true

module Api
  module V1
    class EventRegistrationResource < JSONAPI::Resource
      attributes :user_id, :edu_event_id, :user_data
    end
  end
end
