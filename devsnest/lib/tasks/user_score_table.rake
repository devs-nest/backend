# frozen_string_literal: true

namespace :new_best_sub_table do
  desc 'mark best submissions on new table'
  task data: :environment do
    User.in_batches.update_all(score: 0)
    p 'user scores resetted'
    ch_ids = Challenge.where(is_active: true).pluck(:id)
    submissions = AlgoSubmission.where(is_best_submission: true, challenge_id: ch_ids)

    p 'grouped'
    submissions.each do |best_submission|
      next if best_submission.blank?

      begin
        req_params = best_submission.attributes.slice('user_id', 'challenge_id', 'id', 'total_test_cases', 'passed_test_cases')
        req_params['algo_submission_id'] = req_params.delete('id')
        req_params['score'] = (best_submission.challenge.score * (best_submission.passed_test_cases.to_f / best_submission.total_test_cases))

        existing_record = UserChallengeScore.find_by(user_id: best_submission.user_id, challenge_id: best_submission.challenge_id)

        if existing_record.present?
          existing_record.update(req_params) if req_params['score'] > (existing_record&.score || 0)
        else
          UserChallengeScore.create(req_params)
        end
      rescue StandardError => e
        p "duplicate for #{best_submission.user_id} ch_id: #{best_submission.challenge_id} reason: #{e}"
      end
    end
  end
end
