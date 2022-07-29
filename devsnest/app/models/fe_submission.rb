# frozen_string_literal: true

# Fe submissions model
class FeSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_challenge
  after_save :assign_score, if: :saved_change_to_passed_test_cases?

  def assign_score
    frontend_challenge = FrontendChallenge.find_by_id(frontend_challenge_id)
    return nil if frontend_challenge.blank?

    frontend_challenge.update!(score: score)
    frontend_challenge_score = FrontendChallengeScore.find_by(user_id: user_id, frontend_challenge_id: frontend_challenge_id)

    if frontend_challenge_score.nil?
      FrontendChallengeScore.create!(user_id: user_id, frontend_challenge_id: frontend_challenge.id,
                                     total_test_cases: total_test_cases, passed_test_cases: passed_test_cases, score: score)
    elsif frontend_challenge_score.score < score
      frontend_challenge_score.update!(score: score, fe_submission_id: id, passed_test_cases: passed_test_cases, total_test_cases: total_test_cases)
    end
  end
end
