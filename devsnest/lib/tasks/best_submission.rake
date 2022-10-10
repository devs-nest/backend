# frozen_string_literal: true

namespace :mark_submissions do
  desc 'mark best submissions'
  task data: :environment do
    User.update_all(score: 0)
    AlgoSubmission.update_all(is_best_submission: false)
    submissions = AlgoSubmission.where(is_submitted: true)
    groups = submissions.group_by { |e| [e.user_id, e.challenge_id] }
    groups.each do |k, v|
      submitted_sols = v
      user = User.find_by(id: k[0])
      next if submitted_sols.empty? || user.nil?

      begin
        best_submission = submitted_sols.max { |a, b| a[:passed_test_cases] <=> b[:passed_test_cases] }
        best_submission.update_attribute(:is_best_submission, true)
        user_current_score = user.score
        user_updated_score = user_current_score + (best_submission.challenge.score * (best_submission.passed_test_cases.to_f / best_submission.total_test_cases))
        user.update_attribute(:score, user_updated_score)
        p "updated for #{user.username} : #{user_updated_score}"
      rescue StandardError => e
        p "failed for #{user.username} reason: #{e}"
      end
    end
  end
end
