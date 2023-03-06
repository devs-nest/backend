# frozen_string_literal: true

# == Schema Information
#
# Table name: backend_challenge_scores
#
#  id                   :bigint           not null, primary key
#  passed_test_cases    :integer          default(0)
#  score                :float(24)
#  submitted_url        :text(65535)
#  total_test_cases     :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  backend_challenge_id :integer
#  be_submission_id     :integer
#  user_id              :integer
#
# Indexes
#
#  backend_challenge_score_index  (user_id,backend_challenge_id) UNIQUE
#
class BackendChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :backend_challenge
  belongs_to :be_submission

  after_commit :evaluate_scores

  def evaluate_scores
    EvaluateScoreWorker.perform_async(user_id, 'backend')
  end
end
