module AlgoHelper
  def order_status(status)
    orders = {
      'Pending' => -1,
      'Accepted' => 0,
      'Wrong Answer' => 2,
      'Time Limit Exceeded' => 3,
      'Compilation Error' => 4,
      'Runtime Error (SIGSEGV)' => 5,
      'Runtime Error (SIGABRT)' => 6,
      'Runtime Error (NZEC)' => 7
    }

    if orders.key?(status)
      orders[status]
    else
      -2
    end
  end

  def passed_test_cases_count(submission)
    a = [submission.test_cases.select { |_k, h| h['status_id'] == 3 }.count, submission.passed_test_cases]
    a.max
  end

  def post_to_judgez(batch)
    return if Rails.env.test?

    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'], 'x-rapidapi-host': ENV['JZ_RAPID_HOST'], 'x-rapidapi-key': ENV['JZ_RAPID_KEY'] }
    response = HTTParty.post("#{ENV['JUDGEZERO_URL']}/submissions/batch?base64_encoded=true", body: batch.to_json, headers: jz_headers)
    response.read_body
    # response.code == 201 ? JSON(response.read_body) : nil
  end

  def prepare_test_case_result(data)
    {
      'stdout' => data['stdout'],
      'stderr' => data['stderr'],
      'compile_output' => data['compile_output'],
      'time' => data['time'],
      'memory' => data['memory'],
      'status_id' => data['status']['id'],
      'status_description' => data['status']['description']
    }
  end
end