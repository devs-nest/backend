# frozen_string_literal: true

namespace :run_pendings do
  desc 'rerun pending submission'
  task run: :environment do
    err = []
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'], 'x-rapidapi-key': ENV['JZ_RAPID_KEY'] }
    pending_submissions = AlgoSubmission.where(status: 'Pending').first(100)
    p 'subs fetched'
    done = 0
    err = []
    begin
      pending_submissions.each do |submission|
        submission.update(test_cases: {}, total_test_cases: 0, passed_test_cases: 0, total_memory: 0, total_runtime: 0)
        if submission.is_submitted
          batch, total_test_cases, expected_output_batch, stdins = AlgoSubmission.submit_code({}, submission.language, submission.challenge_id, submission.source_code, submission.id)
        else
          batch, total_test_cases, expected_output_batch, stdins = AlgoSubmission.run_code({}, submission.language, submission.challenge_id, submission.source_code, submission.id)
        end

        tokens = JSON.parse(AlgoSubmission.post_to_judgez({ 'submissions' => batch }))

        zipped_tokens = tokens.zip(expected_output_batch, stdins)
        submission.ingest_tokens(zipped_tokens, submission)

        submission.update(total_test_cases: total_test_cases)
        p "Initiated for #{submission.id}"
      end
    rescue StandardError => e
      p "Error: #{e}"
      err << e
    end
    p err
  end
end
