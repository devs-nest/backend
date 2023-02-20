# frozen_string_literal: true

# == Schema Information
#
# Table name: coding_rooms
#
#  id             :bigint           not null, primary key
#  challenge_list :text(65535)
#  difficulty     :string(255)      not null
#  finish_at      :datetime
#  has_started    :boolean          default(FALSE)
#  is_active      :boolean          default(TRUE)
#  is_private     :boolean          default(FALSE)
#  name           :string(255)
#  question_count :integer          not null
#  room_time      :integer
#  starts_at      :datetime         not null
#  topics         :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  unique_id      :string(255)
#  user_id        :integer          not null
#
# Indexes
#
#  index_coding_rooms_on_finish_at  (finish_at)
#  index_coding_rooms_on_is_active  (is_active)
#  index_coding_rooms_on_unique_id  (unique_id)
#
class CodingRoom < ApplicationRecord
  has_many :coding_room_user_mappings
  has_many :users, through: :coding_room_user_mappings, dependent: :destroy
  has_many :algo_submissions
  has_many :room_best_submissions
  has_many :coding_room_user_mappings

  serialize :challenge_list, Array

  enum room_time: %w[900 1800 3600]
  scope :active, -> { where(is_active: true) }
  scope :public_rooms, -> { where.not(is_private: true) }

  # callbacks
  after_create :update_details
  after_create :close_room
  after_create :generate_leaderboard

  def update_details
    self.update(finish_at: self.starts_at + self.room_time.to_i)
    self.update(unique_id: SecureRandom.hex(6))
  end

  def close_room
    CloseRoomWorker.perform_in(self.finish_at - Time.now, self.id)
    UpdateRoomUserWorker.perform_in(self.finish_at - (Time.now - 1.hours), self.id)
  end

  def generate_leaderboard
    LeaderboardDevsnest::RoomLeaderboard.new(id.to_s)
  end
end
