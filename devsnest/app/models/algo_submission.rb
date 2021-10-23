# frozen_string_literal: true

# algo submissions model
class AlgoSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  def self.add_submission(source_code, lang_id, test_case, challenge_id, mode)
    if mode != 'run'
      inpf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/input/#{test_case[:input_path]}")
      outf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/output/#{test_case[:output_path]}")
    end
    # jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': '4p2j-8mgt-ek0g-sh7m-k9kp' }
    {
      "source_code": source_code,
      "language_id": lang_id,
      "number_of_runs": '1',
      "stdin": mode != 'run' ? Base64.encode64(inpf.body.read || "") : test_case,
      "expected_output": mode != 'run' ? Base64.encode64(outf.body.read || "") : '',
      "cpu_time_limit": '2',
      "cpu_extra_time": '0.5',
      "wall_time_limit": '5',
      "memory_limit": '128000',
      "stack_limit": '64000',
      "max_processes_and_or_threads": '60',
      "enable_per_process_and_thread_time_limit": false,
      "enable_per_process_and_thread_memory_limit": false,
      "max_file_size": '1024',
      "callback_url": ENV['JUDGEZERO_CALLBACK']
    }

    # response = HTTParty.post(ENV['JUDGEZERO_URL'], body: jz_params, headers: jz_headers)
    # puts ENV['JUDGEZERO_URL']
    # puts response.body
    # puts jz_params
    # response.code == 201 ? JSON(response.read_body) : nil
  end

  def self.submit_code(_params, lang_id, challenge_id, source_code)
    test_cases = Testcase.where(challenge_id: challenge_id)
    total_test_cases = 0
    batch = []
    test_cases.each do |test_case|
      total_test_cases += 1
      batch << AlgoSubmission.add_submission(source_code, lang_id, test_case, challenge_id, 'submit')
    end
    [batch, total_test_cases]
  end

  def self.run_code(params, lang_id, challenge_id, source_code)
    test_case = params[:data][:attributes][:test_case]
    mode = 'run'
    if test_case.nil?
      test_case = Testcase.where(challenge_id: challenge_id, is_sample: true).first
      mode = 'run_sample'
    end
    total_test_cases = 1
    [[AlgoSubmission.add_submission(source_code, lang_id, test_case, challenge_id, mode)], total_test_cases]
  end

  def self.post_to_judgez(batch)
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': '4p2j-8mgt-ek0g-sh7m-k9kp' }
    response = HTTParty.post(ENV['JUDGEZERO_URL'], body: batch.to_json, headers: jz_headers)
    response.read_body
    # response.code == 201 ? JSON(response.read_body) : nil
  end

  def self.prepare_test_case_result(data)
    {
      'stdout' => data[:stdout],
      'stderr' => data[:stderr],
      'time' => data[:time],
      'memory' => data[:memory],
      'status_id' => data[:status][:id],
      'status_description' => data[:status][:description]
    }
  end

  def ingest_tokens(tokens)
    tokens.each do |token|
      Judgeztoken.create(submission_id: id, token: token['token'])
    end
  end
end
