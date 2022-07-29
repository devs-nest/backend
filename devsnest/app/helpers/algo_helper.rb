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

    orders.key?(status) ? orders[status] : -2
  end

  def passed_test_cases_count(submission)
    [submission.test_cases.select { |_k, h| h['status_id'] == 3 }.count, submission.passed_test_cases].max
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