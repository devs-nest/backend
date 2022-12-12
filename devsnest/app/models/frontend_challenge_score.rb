# frozen_string_literal: true

# == Schema Information
#
# Table name: frontend_challenge_scores
#
#  id                    :bigint           not null, primary key
#  passed_test_cases     :integer          default(0)
#  score                 :integer
#  total_test_cases      :integer          default(0)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  fe_submission_id      :integer
#  frontend_challenge_id :integer
#  user_id               :integer
#
# Indexes
#
#  frontend_challenge_score_index  (user_id,frontend_challenge_id) UNIQUE
#
class FrontendChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_challenge

  after_commit :evaluate_scores

  def evaluate_scores
    EvaluateScoreWorker.perform_async(user_id, 'frontend')
    User.expire_dashboard_cache(user_id)
  end
end
