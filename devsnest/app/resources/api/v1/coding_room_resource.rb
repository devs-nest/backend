# frozen_string_literal: true

module Api
  module V1
    class CodingRoomResource < JSONAPI::Resource
      attributes :unique_id, :name, :room_time, :is_private, :is_active, :has_started, :created_at, :updated_at, :starts_at, :finish_at, :difficulty, :question_count
    end
  end
end
