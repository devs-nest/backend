# frozen_string_literal: true

# == Schema Information
#
# Table name: coding_room_user_mappings
#
#  id             :bigint           not null, primary key
#  has_left       :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  coding_room_id :bigint           not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_coding_room_user_mappings_on_coding_room_id              (coding_room_id)
#  index_coding_room_user_mappings_on_coding_room_id_and_user_id  (coding_room_id,user_id)
#  index_coding_room_user_mappings_on_user_id                     (user_id)
#  index_coding_room_user_mappings_on_user_id_and_has_left        (user_id,has_left)
#
# Foreign Keys
#
#  fk_rails_...  (coding_room_id => coding_rooms.id)
#  fk_rails_...  (user_id => users.id)
#
class CodingRoomUserMapping < ApplicationRecord
  belongs_to :coding_room
  belongs_to :user
end
