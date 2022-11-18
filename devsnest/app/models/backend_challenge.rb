# frozen_string_literal: true

# == Schema Information
#
# Table name: backend_challenges
#
#  id                   :bigint           not null, primary key
#  day_no               :integer
#  difficulty           :integer
#  is_active            :boolean          default(FALSE)
#  name                 :string(255)
#  question_body        :text(65535)
#  score                :integer          default(0)
#  slug                 :string(255)
#  testcases_path       :string(255)
#  topic                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  user_id              :integer
#
# Indexes
#
#  index_backend_challenges_on_slug  (slug) UNIQUE
#
require 'rspec/core'
# backend challenge model
class BackendChallenge < ApplicationRecord
  include ApplicationHelper
  enum difficulty: %i[easy medium hard]
  enum topic: %i[test]
  has_many :backend_challenge_scores
  has_many :be_submissions
  has_many :assignment_questions
  belongs_to :course_curriculum
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug, case_sensitive: true
  # before_save :expire_cache
  before_save :regenerate_challenge_leaderboard, if: :will_save_change_to_score?
  before_update :recalculate_user_scores, if: :will_save_change_to_is_active?

  def create_slug
    update(slug: name.parameterize)
  end

  def recalculate_user_scores
    UserScoreUpdate.perform_async(id, 'backend')
  end

  def regenerate_challenge_leaderboard
    leaderboard = LeaderboardDevsnest::BeLeaderboard.new("#{slug}-lb").call
    leaderboard.delete_leaderboard
    best_submissions = BackendChallengeScore.where(backend_challenge_id: id)

    best_submissions.each do |submission|
      calc_score = score * (submission.passed_test_cases / submission.total_test_cases.to_f)
      submission.update(score: calc_score)
      leaderboard.rank_member(submission.user.username, calc_score)
    end
  end

  def self.count_solved(user_id)
    challenge_ids = BackendChallengeScore.where(user_id: user_id).where('passed_test_cases = total_test_cases').pluck(:backend_challenge_id)
    BackendChallenge.where(id: challenge_ids, is_active: true).group(:topic).count
  end

  def self.split_by_topic
    where(is_active: true).group(:topic).count
  end

  def give_test_case_report(url)
    error_stream = StringIO.new
    output_stream = StringIO.new
    ENV['url'] = url
    status = RSpec::Core::Runner.run([testcases_path, '--format=json'], error_stream, output_stream).zero?
    RSpec.reset
    total_passed = 0
    total_failed = 0
    failed_test_cases_desc = []
    passed_test_cases_desc = []
    output_stream = JSON.parse(output_stream.string)
    output_stream['examples'].each do |example|
      if example['status'] == 'passed'
        total_passed += 1
        passed_test_cases_desc.push(example['description'])
      else
        total_failed += 1
        failed_test_cases_desc.push(example['description'])
      end
    end
    { all_test_passed: status, total_test_cases: total_passed + total_failed, total_passed: total_passed, total_failed: total_failed,
      failed_test_cases_desc: failed_test_cases_desc, passed_test_cases_desc: passed_test_cases_desc }
  end
end
