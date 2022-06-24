# frozen_string_literal: true

namespace :mark_selected_submissions do
  desc 'mark best submissions'
  task data: :environment do
    User.in_batches.update_all(score: 0)
    AlgoSubmission.in_batches.update_all(is_best_submission: false)
    ch_ids = Challenge.where(is_active: true).pluck(:id)

    ch_ids.each do |ch_id|
      p "running for ch:#{ch_id}"
      submissions = AlgoSubmission.where(challenge_id: ch_id, is_submitted: true)
      groups = submissions.group_by { |e| [e.user_id] }
      p "grouped"
      groups.each do |k, v|
        submitted_sols = v
        user = User.find_by(id: k)
        next if submitted_sols.empty? || user.nil?
  
        begin
          best_submission = submitted_sols.max { |a, b| a[:passed_test_cases] <=> b[:passed_test_cases] }
          best_submission.update_attribute(:is_best_submission, true)
          user_current_score = user.score
          user_updated_score = user_current_score + (best_submission.challenge.score * (best_submission.passed_test_cases.to_f / best_submission.total_test_cases))
          user.update_attribute(:score, user_updated_score)
          p "updated for #{user.username} : #{user_updated_score}"
        rescue => e
          p "failed for #{user.username} reason: #{e}"
        end
      end
    end
  end
end