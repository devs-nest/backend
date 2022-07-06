# frozen_string_literal: true

namespace :new_best_sub_table do
  desc 'mark best submissions on new table'
  task data: :environment do
    User.in_batches.update_all(score: 0)
    p "user scores resetted"
    AlgoSubmission.in_batches.update_all(is_best_submission: false)
    p "best sub resetted"
    ch_ids = Challenge.where(is_active: true).pluck(:id)

    ch_ids.each do |ch_id|
      p "running for ch:#{ch_id}"
      submissions = AlgoSubmission.where(is_submitted: true, challenge_id: ch_id)
      groups = submissions.group_by { |e| [e.user_id] }
      p "grouped"
      groups.each do |k, v|
        submitted_sols = v
        user = User.find_by(id: k)
        next if submitted_sols.empty? || user.nil?
  
        begin
          best_submission = submitted_sols.max { |a, b| a[:passed_test_cases] <=> b[:passed_test_cases] }
          req_params = best_submission.attributes.slice("user_id", "challenge_id", "id", "total_test_cases", "passed_test_cases")
          req_params["algo_submission_id"] = req_params.delete("id")
          req_params["score"] = (best_submission.challenge.score * (best_submission.passed_test_cases.to_f / best_submission.total_test_cases))

          UserChallengeScore.create(req_params)
        rescue => e
          p "failed for #{user.username} reason: #{e}"
        end
      end
    end
  end
end