# frozen_string_literal: true

# Fe submissions model
class FeSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_challenge
  after_save :assign_score, if: :saved_change_to_passed_test_cases?

  def assign_score
    passed_tests = [passed_test_cases.to_i, total_test_cases.to_i].min
    total_tests = total_test_cases.to_i
    final_score = frontend_challenge.score * (passed_tests / total_tests.to_f)
    update!(score: final_score)
    frontend_challenge_score = FrontendChallengeScore.find_by(user_id: user_id, frontend_challenge_id: frontend_challenge_id)

    if frontend_challenge_score.nil?
      FrontendChallengeScore.create!(user_id: user_id, frontend_challenge_id: frontend_challenge_id,
                                     total_test_cases: total_test_cases, passed_test_cases: passed_test_cases, score: final_score)
    elsif frontend_challenge_score.score < final_score
      frontend_challenge_score.update!(score: final_score, fe_submission_id: id, passed_test_cases: passed_test_cases, total_test_cases: total_test_cases)
    end
  end
end
