# frozen_string_literal: true

# == Schema Information
#
# Table name: user_challenge_scores
#
#  id                 :bigint           not null, primary key
#  passed_test_cases  :integer
#  score              :integer          default(0)
#  total_test_cases   :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  algo_submission_id :integer
#  challenge_id       :integer
#  user_id            :integer
#
# Indexes
#
#  index_user_challenge_scores_on_user_id_and_challenge_id  (user_id,challenge_id) UNIQUE
#
class UserChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  after_commit :evaluate_scores

  def evaluate_scores
    EvaluateScoreWorker.perform_async(user_id, 'dsa')
    User.expire_dashboard_cache(user_id)
  end
end
