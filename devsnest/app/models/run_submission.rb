# frozen_string_literal: true

# == Schema Information
#
# Table name: run_submissions
#
#  id                :bigint           not null, primary key
#  language          :string(255)
#  passed_test_cases :integer          default(0)
#  source_code       :text(65535)
#  status            :string(255)
#  test_cases        :json
#  total_memory      :string(255)
#  total_runtime     :string(255)
#  total_test_cases  :integer          default(0)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  challenge_id      :integer
#  user_id           :integer
#
# Indexes
#
#  index_run_submissions_on_user_id_and_challenge_id  (user_id,challenge_id)
#
class RunSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  def self.run_code(params, lang, challenge_id, source_code, submission_id)
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

  def ingest_tokens(tokens, submission)
    tokens.each do |token, expected_output, stdin|
      tstring = token['token'].to_s
      Judgeztoken.create(submission_id: id, token: tstring)

      submission.test_cases[tstring] = { 'expected_output' => expected_output, 'stdin' => stdin }
      submission.save!
    end
  end
end
