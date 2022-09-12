# frozen_string_literal: true

class UserChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  after_commit :evaluate_scores

  def evaluate_scores
    EvaluateScoreWorker.perform_async(user_id, 'dsa')
  end
end
