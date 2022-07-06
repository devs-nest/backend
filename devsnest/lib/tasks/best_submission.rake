# frozen_string_literal: true

namespace :mark_submissions do
  desc 'mark best submissions'
  task data: :environment do
    AlgoSubmission.update_all(is_best_submission: false)
    p "fetched sub"
    ch_ids = Challenge.where(is_active: true).pluck(:id)

    submissions = AlgoSubmission.where(is_submitted: true, challenge_id: ch_ids)
    groups = submissions.group_by { |e| [e.user_id, e.challenge_id] }
    done = 0
    groups.each do |k, v|
      submitted_sols = v
      user = User.find_by(id: k[0])
      next if submitted_sols.empty? || user.nil?

      begin

        best_submission = submitted_sols.max { |a, b| a[:passed_test_cases] <=> b[:passed_test_cases] }
        best_submission.update_column(:is_best_submission, true)
        done += 1
        p "updated for #{user.username} count : #{done}"
      rescue => e
        p "failed for #{user.username} reason: #{e}"
      end
    end
  end
end