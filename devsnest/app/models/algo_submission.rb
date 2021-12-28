# frozen_string_literal: true

# algo submissions model
class AlgoSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  after_commit :assign_score_to_user, if: :score_should_be_updated, on: %i[create update]

  def self.add_submission(source_code, lang, test_case, challenge_id, mode)
    if mode != 'run'
      begin
        inpf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/input/#{test_case[:input_path]}").body.read
        outf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/output/#{test_case[:output_path]}").body.read
      rescue StandardError
        return { 'error' => 'Something went wrong!' }
      end
    end

    stdin = Base64.encode64(inpf || '') if mode == 'run_sample'
    expected_out = Base64.encode64(outf || '') if mode == 'run_sample'
    # jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': '4p2j-8mgt-ek0g-sh7m-k9kp' }
    payload = {
      "source_code": source_code,
      "language_id": Devsnest::Application::JUDGEZERO_OPTIONS[lang][:id],
      "number_of_runs": '1',
      "stdin": mode != 'run' ? Base64.encode64(inpf || '') : test_case,
      "expected_output": mode != 'run' ? Base64.encode64(outf || '') : '',
      "cpu_time_limit": Devsnest::Application::JUDGEZERO_OPTIONS[lang][:time_limit] || '2',
      "cpu_extra_time": '0.5',
      "wall_time_limit": '5',
      "memory_limit": Devsnest::Application::JUDGEZERO_OPTIONS[lang][:memory_limit] || '512000',
      "stack_limit": '64000',
      "max_processes_and_or_threads": '10',
      "enable_per_process_and_thread_time_limit": false,
      "enable_per_process_and_thread_memory_limit": false,
      "max_file_size": '1024',
      "callback_url": ENV['JUDGEZERO_CALLBACK']
    }

    [payload, expected_out, stdin]
  end

  def self.submit_code(_params, lang, challenge_id, source_code)
    test_cases = Testcase.where(challenge_id: challenge_id)
    total_test_cases = 0
    batch = []
    expected_output_batch = []
    stdins = []
    test_cases.each do |test_case|
      loader, expected_output, stdin = AlgoSubmission.add_submission(source_code, lang, test_case, challenge_id, 'submit')
      next if loader.key?('error')

      batch << loader
      expected_output_batch << expected_output
      stdins << stdin
      total_test_cases += 1
    end
    [batch, total_test_cases, expected_output_batch, stdins]
  end

  def self.run_code(params, lang, challenge_id, source_code)
    test_case = params[:data][:attributes][:test_case]
    mode = 'run'
    batch = []
    expected_output_batch = []
    stdins = []
    if test_case.nil?
      test_case = Testcase.where(challenge_id: challenge_id, is_sample: true).first
      mode = 'run_sample'
    end
    total_test_cases = 1
    loader, expected_output, stdin = AlgoSubmission.add_submission(source_code, lang, test_case, challenge_id, mode)
    batch << loader
    expected_output_batch << expected_output
    stdins << stdin
    [batch, total_test_cases, expected_output_batch, stdins]
  end

  def self.post_to_judgez(batch)
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'] }
    response = HTTParty.post(ENV['JUDGEZERO_URL'] + '/submissions/batch?base64_encoded=true', body: batch.to_json, headers: jz_headers)
    response.read_body
    # response.code == 201 ? JSON(response.read_body) : nil
  end

  def self.prepare_test_case_result(data)
    {
      'stdout' => data['stdout'],
      'stderr' => data['stderr'],
      'time' => data['time'],
      'memory' => data['memory'],
      'status_id' => data['status']['id'],
      'status_description' => data['status']['description']
    }
  end

  def ingest_tokens(tokens, submission)
    tokens.each do |token, expected_output, stdin|
      tstring = token['token'].to_s
      Judgeztoken.create(submission_id: id, token: tstring)
      JudgeZWorker.perform_in(3.minutes, tstring, id)

      submission.test_cases[tstring] = { 'expected_output' => expected_output, 'stdin' => stdin }
      submission.save!
    end
  end

  def self.order_status(status)
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

  def assign_score_to_user
    user = User.find(self.user_id)
    challenge = Challenge.find(self.challenge_id)
    previous_passed_test_cases = AlgoSubmission.where(user_id: self.user_id, challenge_id: self.challenge_id, is_submitted: true).offset(1).pluck(:passed_test_cases).max
    previous_max_score = previous_passed_test_cases.nil? ? 0 : (previous_passed_test_cases / challenge.testcases.count) * challenge.score
    new_score = (passed_test_cases / challenge.testcases.count) * challenge.score
    if previous_max_score < new_score
      recalculated_score_of_user = user.score - previous_max_score + new_score
      user.update!(score: recalculated_score_of_user)
    end
  end

  def score_should_be_updated
    ['Pending', 'Compilation Error'].exclude?(self.status) && self.is_submitted
  end
end
