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
end