# frozen_string_literal: true

class FrontendChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_challenge

  after_commit :evaluate_scores

  def evaluate_scores
    EvaluateScoreWorker.perform_async(user_id, 'frontend')
  end
end
