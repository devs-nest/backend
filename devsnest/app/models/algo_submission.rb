# frozen_string_literal: true

# == Schema Information
#
# Table name: algo_submissions
#
#  id                 :bigint           not null, primary key
#  is_best_submission :boolean          default(FALSE)
#  is_submitted       :boolean
#  language           :string(255)
#  passed_test_cases  :integer          default(0)
#  source_code        :text(65535)
#  status             :string(255)
#  test_cases         :json
#  total_memory       :string(255)
#  total_runtime      :string(255)
#  total_test_cases   :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  challenge_id       :integer
#  coding_room_id     :integer
#  user_id            :integer
#
# Indexes
#
#  index_algo_submissions_on_challenge_id_and_coding_room_id  (challenge_id,coding_room_id)
#  index_algo_submissions_on_is_submitted_and_status          (is_submitted,status)
#  index_algo_submissions_on_user_id_and_challenge_id         (user_id,challenge_id)
#
class AlgoSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge
  belongs_to :coding_room, optional: true
  after_commit :assign_score_to_user, if: :execution_completed, on: %i[create update]
  after_commit :expire_cache
  after_commit :assign_score_into_rooms, if: :execution_completed, on: %i[create update]
  include AlgoHelper

  scope :accessible, -> { where.not(status: 'Stale') }

  def self.add_submission(source_code, lang, test_case, mode, submission_id = nil)
    controller = %w[run run_sample].include?(mode) ? 'run-submission' : 'algo-submission'
    if mode != 'run'
      inpf = test_case.input_case
      outf = test_case.output_case

      return { 'error' => 'Something went wrong!' } if inpf.nil? || outf.nil?
    end

    stdin = Base64.encode64(inpf || '')
    expected_out = Base64.encode64(outf || '')
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
      "callback_url": ENV['JUDGEZERO_CALLBACK'] + "/api/v1/#{controller}/callback" + "?submission_id=#{submission_id}"
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

  def self.post_to_judgez(batch)
    jz_headers = { 'Content-Type': 'application/json', 'X-Auth-Token': ENV['JUDGEZERO_AUTH'], 'x-rapidapi-host': ENV['JZ_RAPID_HOST'], 'x-rapidapi-key': ENV['JZ_RAPID_KEY'] }
    response = HTTParty.post("#{ENV['JUDGEZERO_URL']}/submissions/batch?base64_encoded=true", body: batch.to_json, headers: jz_headers)
    response.read_body
    # response.code == 201 ? JSON(response.read_body) : nil
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

  def assign_score_to_user
    user = User.get_by_cache(user_id)
    challenge = Challenge.find(challenge_id)
    return unless challenge.is_active || is_submitted

    score_will_change = false
    user.update(dsa_streak: user.dsa_streak + 1, streak_end_date: DateTime.current.to_date) if user.streak_end_date.blank? || DateTime.current.to_date > user.streak_end_date

    previous_best_submission = UserChallengeScore.find_by(user_id: user.id, challenge_id: challenge.id)

    if previous_best_submission.nil? || previous_best_submission.passed_test_cases < passed_test_cases
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

  def assign_score_into_rooms
    return unless coding_room_id.present?

    user_room_map = CodingRoomUserMapping.find_by(coding_room_id: coding_room_id, user_id: user_id)
    return if user_room_map.nil? || user_room_map.has_left == true

    user = User.get_by_cache(user_id)
    challenge = Challenge.find(challenge_id)

    previous_best_submission = RoomBestSubmission.find_by(user_id: user.id, challenge_id: challenge_id, coding_room_id: coding_room_id)

    return unless previous_best_submission.nil? || previous_best_submission.passed_test_cases < passed_test_cases

    best_submission = self
    new_score = (passed_test_cases / total_test_cases.to_f) * challenge.score || 0
    AlgoSubmission.update_room_best_submission(coding_room_id, best_submission, id, new_score)
    user_score = RoomBestSubmission.where(coding_room_id: coding_room_id, user_id: user.id).sum(:score)
    lb = LeaderboardDevsnest::RoomLeaderboard.new(coding_room_id.to_s).call
    current_score = lb.score_for(user.username) || 0
    lb.rank_member(user.username, user_score) if current_score < user_score
  end

  def execution_completed
    ['Pending', 'Compilation Error'].exclude?(status) && is_submitted
  end

  def self.update_room_best_submission(room_id, best_submission, current_submission_id, score)
    entry = RoomBestSubmission.find_by(user_id: best_submission.user_id, challenge_id: best_submission.challenge_id, coding_room_id: room_id)

    if entry.present?
      entry.assign_attributes({
                                score: score,
                                algo_submission_id: current_submission_id,
                                passed_test_cases: best_submission.passed_test_cases,
                                total_test_cases: best_submission.total_test_cases
                              })
      entry.save!
    else
      RoomBestSubmission.create(
        user_id: best_submission.user_id,
        challenge_id: best_submission.challenge_id,
        coding_room_id: room_id,
        score: score,
        algo_submission_id: current_submission_id,
        passed_test_cases: best_submission.passed_test_cases,
        total_test_cases: best_submission.total_test_cases
      )
    end
  end

  def self.update_best_submission(best_submission, _previous_best_submission, current_submission_id, score)
    entry = UserChallengeScore.find_by(user_id: best_submission.user_id, challenge_id: best_submission.challenge_id)

    if entry.present?
      entry.assign_attributes({
                                score: score,
                                algo_submission_id: current_submission_id,
                                passed_test_cases: best_submission.passed_test_cases,
                                total_test_cases: best_submission.total_test_cases
                              })
      entry.save!
    else
      UserChallengeScore.create(
        user_id: best_submission.user_id,
        challenge_id: best_submission.challenge_id,
        score: score,
        algo_submission_id: current_submission_id,
        passed_test_cases: best_submission.passed_test_cases,
        total_test_cases: best_submission.total_test_cases
      )
    end
  end

  def expire_cache
    Rails.cache.delete("algo_submissions_#{user_id}_#{challenge_id}")
  end
end
