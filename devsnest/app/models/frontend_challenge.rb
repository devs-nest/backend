# frozen_string_literal: true

# FrontendChallenge class
class FrontendChallenge < ApplicationRecord
  include ApplicationHelper
  enum difficulty: %i[easy medium hard]
  enum topic: %i[html css javascript react]
  has_many :frontend_challenge_scores
  has_many :assingment_questions
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug, case_sensitive: true
  before_save :expire_cache
  before_save :regenerate_challenge_leaderboard, if: :will_save_change_to_score?
  before_update :recalculate_user_scores, if: :will_save_change_to_is_active?

  def recalculate_user_scores
    UserScoreUpdate.perform_async(id, 'frontend')
  end

  def regenerate_challenge_leaderboard
    # TODO
    LeaderboardDevsnest::AlgoLeaderboard.new("#{slug}-lb").call.delete_leaderboard
    leaderboard = LeaderboardDevsnest::AlgoLeaderboard.new("#{slug}-lb").call
    best_submissions = FrontendChallengeScore.where(challenge_id: id)

    best_submissions.each do |submission|
      calc_score = score * (submission.passed_test_cases / submission.total_test_cases.to_f)
      submission.update(score: calc_score)
      leaderboard.rank_member(submission.user.username, calc_score)
    end
  end

  def create_slug
    update(slug: name.parameterize)
  end

  def fetch_files_s3(bucket, prefix)
    data = {}

    files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}#{bucket}", prefix: "#{prefix}/")

    files.contents.each do |file|
      next if challenge_type == 'github' && file.key.to_s == testcases_path

      path = file.key.to_s.sub(prefix, '')
      content = $s3.get_object(bucket: "#{ENV['S3_PREFIX']}#{bucket}", key: file.key).body.read.to_s
      data[path.to_s] = content.to_s
    end
    data.as_json
  end

  def read_from_s3
    Rails.cache.fetch('frontend_challenge_' + id.to_s) { fetch_files_s3('frontend-testcases', id.to_s) }
  end

  private

  def expire_cache
    Rails.cache.delete('frontend_challenge_' + id.to_s)
  end
end
