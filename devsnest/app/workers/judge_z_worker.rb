class JudgeZWorker
  include Sidekiq::Worker
  include AlgoHelper

  def perform(token, submission_id)
    return if token.empty? || token.nil? || submission_id.nil?

    submission = AlgoSubmission.get_by_cache(submission_id)
    return if submission.nil? || submission.test_cases.key?(token.to_s).blank? || submission.test_cases.dig(token.to_s, "status_id").present?

    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'] }
    poll = HTTParty.get(ENV['JUDGEZERO_URL']+"/submissions/#{token.to_s}?base64_encoded=true", headers: jz_headers)
    submission.with_lock do
      res_hash = AlgoSubmission.prepare_test_case_result(JSON(poll.body))
      if order_status(submission.status) <= order_status(res_hash["status_description"])
        submission.status = res_hash["status_description"]
      end
      submission.total_runtime = submission.total_runtime.to_f + res_hash["time"].to_f
      submission.total_memory = submission.total_memory.to_i + res_hash["memory"].to_i
      submission.test_cases[token.to_s] = submission.test_cases[token.to_s].merge(res_hash)
      submission.passed_test_cases = passed_test_cases_count(submission)
      submission.status = 'Pending' if submission.status == 'Accepted' && submission.total_test_cases != submission.passed_test_cases
      submission.save!
    end
  end
end
