# frozen_string_literal: true

# Close the room after the time is over
class CloseRoomWorker
  include Sidekiq::Worker

  def perform(coding_room_id)
    CodingRoom.find(coding_room_id).update(is_active: false)
  end
end
