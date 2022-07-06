# frozen_string_literal: true

# algo submissions model
class AlgoSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  after_commit :assign_score_to_user, if: :execution_completed, on: %i[create update]

  scope :accessible, -> { where.not(status: 'Stale') }

  def self.add_submission(source_code, lang, test_case, mode, submission_id = nil)
    if mode != 'run'
      inpf = test_case.input_case
      outf = test_case.output_case

      return { 'error' => 'Something went wrong!' } if inpf.nil? || outf.nil?
    end

    stdin = Base64.encode64(inpf || '')
    expected_out = Base64.encode64(outf || '')
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
      "max_processes_and_or_threads": '120',
      "enable_per_process_and_thread_time_limit": false,
      "enable_per_process_and_thread_memory_limit": false,
      "max_file_size": '4096',
      "callback_url": ENV['JUDGEZERO_CALLBACK'] + "?submission_id=#{submission_id}"
    }

    [payload, expected_out, stdin]
  end

  def self.submit_code(_params, lang, challenge_id, source_code, submission_id = nil)
    test_cases = Testcase.where(challenge_id: challenge_id)
    total_test_cases = 0
    batch = []
    expected_output_batch = []
    stdins = []
    test_cases.each do |test_case|
      loader, expected_output, stdin = AlgoSubmission.add_submission(source_code, lang, test_case, 'submit', submission_id)
      next if loader.key?('error')

      batch << loader
      expected_output_batch << expected_output
      stdins << stdin
      total_test_cases += 1
    end
    [batch, total_test_cases, expected_output_batch, stdins]
  end

  def self.run_code(params, lang, challenge_id, source_code, submission_id = nil)
    test_case = params.dig(:data, :attributes, :test_case)
    mode = 'run'
    batch = []
    expected_output_batch = []
    stdins = []
    if test_case.nil?
      test_case = Testcase.where(challenge_id: challenge_id, is_sample: true).first
      mode = 'run_sample'
    end
    total_test_cases = 1
    loader, expected_output, stdin = AlgoSubmission.add_submission(source_code, lang, test_case, mode, submission_id)
    batch << loader
    expected_output_batch << expected_output
    stdins << stdin
    [batch, total_test_cases, expected_output_batch, stdins]
  end

  def self.post_to_judgez(batch)
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'], 'x-rapidapi-host': ENV['JZ_RAPID_HOST'], 'x-rapidapi-key': ENV['JZ_RAPID_KEY'] }
    response = HTTParty.post("#{ENV['JUDGEZERO_URL']}/submissions/batch?base64_encoded=true", body: batch.to_json, headers: jz_headers)
    response.read_body
    # response.code == 201 ? JSON(response.read_body) : nil
  end

  def self.prepare_test_case_result(data)
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

  def ingest_tokens(tokens, submission)
    tokens.each do |token, expected_output, stdin|
      tstring = token['token'].to_s
      Judgeztoken.create(submission_id: id, token: tstring)

      submission.with_lock do
        submission.test_cases[tstring] ||= {}
        submission.test_cases[tstring] = submission.test_cases[tstring].merge({ 'expected_output' => expected_output, 'stdin' => stdin })
        submission.save!
      end
    end

    tokens.each do |token, _expected_output, _stdin|
      tstring = token['token'].to_s
      JudgeZWorker.perform_in(1.minutes, tstring, id)
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
    user = User.get_by_cache(user_id)
    challenge = Challenge.find(challenge_id)
    return unless challenge.is_active || is_submitted

    score_will_change = false

    previous_best_submission = UserChallengeScore.find_by(user_id: user.id, challenge_id: challenge.id)

    if previous_best_submission.nil? || previous_best_submission.passed_test_cases < self.passed_test_cases
      score_will_change = true
      best_submission = self
    end

    if score_will_change
      new_score = (passed_test_cases / total_test_cases.to_f) * challenge.score || 0
      ch_lb = challenge.generate_leaderboard
      ch_lb.rank_member(user.username.to_s, challenge.score * (passed_test_cases.to_f / total_test_cases))
      AlgoSubmission.update_best_submission(best_submission, previous_best_submission, id, new_score)
    end
  end

  def execution_completed
    ['Pending', 'Compilation Error'].exclude?(status) && is_submitted
  end

  def self.update_best_submission(best_submission, _previous_best_submission, current_submission_id, score)
    entry = UserChallengeScore.find_by(user_id: best_submission.user_id, challenge_id: best_submission.challenge_id)
    if entry.present?
      entry.assign_attributes({
                                challenge_active: best_submission.challenge.is_active,
                                score: score,
                                algo_submission_id: current_submission_id,
                                passed_test_cases: best_submission.passed_test_cases,
                                total_test_cases: best_submission.total_test_cases
                              })
      entry.save!
    else
      entry = UserChallengeScore.create(
        user_id: best_submission.user_id, 
        challenge_id: best_submission.challenge_id,
        challenge_active: best_submission.challenge.is_active,
        score: score,
        algo_submission_id: current_submission_id,
        passed_test_cases: best_submission.passed_test_cases,
        total_test_cases: best_submission.total_test_cases
      )
    end
  end

  def passed_test_cases_count
    a = [test_cases.select { |_k, h| h['status_id'] == 3 }.count, passed_test_cases]
    a.max
  end
end
