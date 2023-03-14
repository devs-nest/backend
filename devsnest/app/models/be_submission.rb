# frozen_string_literal: true

# == Schema Information
#
# Table name: be_submissions
#
#  id                     :bigint           not null, primary key
#  failed_test_cases_desc :text(65535)
#  passed_test_cases      :integer          default(0)
#  passed_test_cases_desc :text(65535)
#  score                  :float(24)
#  status                 :string(255)
#  submitted_url          :text(65535)
#  total_test_cases       :integer          default(0)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  backend_challenge_id   :integer
#  user_id                :integer
#
# Indexes
#
#  backend_submission_user_index  (user_id,backend_challenge_id)
#
# Model
class BeSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :backend_challenge
  after_save :assign_score, if: :saved_change_to_passed_test_cases?
  after_create_commit :run_test_cases, if: :saved_change_to_submitted_url?
  serialize :failed_test_cases_desc, Array
  serialize :passed_test_cases_desc, Array

  def assign_score
    passed_tests = [passed_test_cases.to_i, total_test_cases.to_i].min
    final_score = backend_challenge.score * (passed_tests / total_test_cases.to_f)
    update!(score: final_score)
    backend_challenge_score = BackendChallengeScore.find_or_create_by(user_id: user_id, backend_challenge_id: backend_challenge_id)

    backend_challenge_score.update!(score: final_score, be_submission_id: id, passed_test_cases: passed_test_cases, total_test_cases: total_test_cases)
    Rails.cache.delete("user_be_submission_#{user_id}_#{backend_challenge_id}") if Rails.cache.fetch("user_be_submission_#{user_id}_#{backend_challenge_id}") != 'solved'
  end

  def self.validate_uri(uri)
    uri_regex = %r{^(http|https)://[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,5}$}
    return false unless uri.match(uri_regex)

    parsed_uri = URI.parse(uri)
    http_request = Net::HTTP.new(parsed_uri.host, parsed_uri.port)
    http_request.use_ssl = (parsed_uri.scheme == 'https')
    http_request.request_head('/')
    true
  rescue SocketError
    false
  end

  def run_test_cases
    BeEvaluationWorker.perform_async(id)
  end
end
