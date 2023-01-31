# frozen_string_literal: true

# == Schema Information
#
# Table name: room_best_submissions
#
#  id                 :bigint           not null, primary key
#  passed_test_cases  :integer
#  score              :integer
#  total_test_cases   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  algo_submission_id :integer
#  challenge_id       :integer
#  coding_room_id     :integer
#  user_id            :integer
#
# Indexes
#
#  index_room_best_submission  (user_id,challenge_id,coding_room_id) UNIQUE
#
class RoomBestSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  belongs_to :coding_room
end
