# frozen_string_literal: true

# Make user leave the room if he/she is still in the room
class UpdateRoomUserWorker
  include Sidekiq::Worker

  def perform(coding_room_id)
    CodingRoomUserMapping.where(coding_room_id: coding_room_id, has_left: false).update_all(has_left: true)
  end
end
