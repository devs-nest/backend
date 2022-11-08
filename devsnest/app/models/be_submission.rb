# == Schema Information
#
# Table name: be_submissions
#
#  id                   :bigint           not null, primary key
#  failed_test_cases    :text(65535)
#  passed_test_cases    :integer          default(0)
#  score                :float(24)
#  status               :string(255)
#  submitted_url        :text(65535)
#  total_test_cases     :integer          default(0)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  backend_challenge_id :integer
#  user_id              :integer
#
# Indexes
#
#  backend_submission_user_index  (user_id,backend_challenge_id)
#
class BeSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :backend_challenge
  after_save :assign_score, if: :saved_change_to_passed_test_cases?
  serialize :failed_test_cases, Array

  def assign_score
    passed_tests = [passed_test_cases.to_i, total_test_cases.to_i].min
    final_score = backend_challenge.score * (passed_tests / total_test_cases.to_f)
    update!(score: final_score)
    backend_challenge_score = BackendChallengeScore.find_or_create_by(user_id: user_id, backend_challenge_id: backend_challenge_id)

    backend_challenge_score.update!(score: final_score, be_submission_id: id, passed_test_cases: passed_test_cases, total_test_cases: total_test_cases)
  end
end
