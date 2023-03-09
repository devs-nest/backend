# frozen_string_literal: true

# == Schema Information
#
# Table name: fe_submissions
#
#  id                    :bigint           not null, primary key
#  is_submitted          :boolean          default(FALSE)
#  passed_test_cases     :integer          default(0)
#  question_type         :string(255)
#  result                :text(65535)
#  score                 :integer
#  source_code           :text(65535)
#  status                :string(255)
#  total_test_cases      :integer          default(0)
#  created_at            :datetime
#  updated_at            :datetime
#  frontend_challenge_id :integer
#  user_id               :integer
#
# Indexes
#
#  frontend_submission_user_index  (user_id,frontend_challenge_id)
#
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

    Rails.cache.delete("user_fe_submission_#{user_id}_#{frontend_challenge_id}") if Rails.cache.fetch("user_fe_submission_#{user_id}_#{frontend_challenge_id}") != 'solved'
  end
end
