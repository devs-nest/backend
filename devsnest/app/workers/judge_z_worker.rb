class JudgeZWorker
  include Sidekiq::Worker

  def perform(token, submission_id)
    return if token.nil? || submission_id.nil?

    submission = AlgoSubmission.find(submission_id)
    return if submission.nil? || submission.test_cases.dig(token.to_s, status_id).present?

    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'] }
    poll = HTTParty.get(ENV['JUDGEZERO_URL']+"/submissions/#{token.to_s}?base64_encoded=true", headers: jz_headers)
    submission.with_lock do
      res_hash = AlgoSubmission.prepare_test_case_result(JSON(poll.body))
      if AlgoSubmission.order_status(submission.status) <= AlgoSubmission.order_status(res_hash["status_description"])
        submission.status = res_hash["status_description"]
      end
      submission.total_runtime = submission.total_runtime.to_f + res_hash["time"].to_f
      submission.total_memory = submission.total_memory.to_i + res_hash["memory"].to_i
      submission.test_cases[token.to_s] = submission.test_cases[token.to_s].merge(res_hash)
      submission.passed_test_cases += 1 if res_hash["status_id"] == 3
      submission.status = 'Pending' if submission.status == 'Accepted' && submission.total_test_cases != submission.passed_test_cases
      submission.save!
    end
  end
end
