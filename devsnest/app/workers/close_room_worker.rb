# frozen_string_literal: true

class CloseRoomWorker
  include Sidekiq::Worker

  def perform(coding_room_id)
    CodingRoom.find(coding_room_id).update(is_active: false)
    CodingRoomUserMapping.where(coding_room_id: coding_room_id).update_all(has_left: true)
  end
end
