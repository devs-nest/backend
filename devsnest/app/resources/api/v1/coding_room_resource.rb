# frozen_string_literal: true

module Api
  module V1
    class CodingRoomResource < JSONAPI::Resource
      attributes :unique_id, :name, :room_time, :challenge_list, :is_private, :is_active, :has_started, :created_at, :updated_at
    end
  end
end
