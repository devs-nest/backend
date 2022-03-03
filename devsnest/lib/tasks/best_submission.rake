# frozen_string_literal: true

namespace :mark_submissions do
  desc 'mark best submissions'
  task data: :environment do
    submissions = AlgoSubmission.all
    groups = submissions.group_by {|e| [e.user_id, e.challenge_id]}
    groups.each do |k, v|
      submitted_sols = v.select {|e| e.is_submitted}
      tbu = submitted_sols.max {|a, b| a[:passed_test_cases] <=> b[:passed_test_cases]}
      tbu.update_attribute(:is_best_submission, true)
    end
  end
end
