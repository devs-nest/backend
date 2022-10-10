# frozen_string_literal: true

# == Schema Information
#
# Table name: frontend_challenges
#
#  id                   :bigint           not null, primary key
#  active_path          :string(255)
#  challenge_type       :string(255)
#  day_no               :integer
#  difficulty           :integer
#  files                :text(65535)
#  folder_name          :string(255)
#  hidden_files         :text(65535)
#  is_active            :boolean          default(FALSE)
#  name                 :string(255)
#  open_paths           :text(65535)
#  protected_paths      :text(65535)
#  question_body        :text(65535)
#  score                :integer          default(0)
#  slug                 :string(255)
#  template             :string(255)
#  testcases_path       :string(255)
#  topic                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  user_id              :integer
#
# Indexes
#
#  index_frontend_challenges_on_slug  (slug) UNIQUE
#
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

  has_paper_trail

  def recalculate_user_scores
    UserScoreUpdate.perform_async(id, 'frontend')
  end

  def regenerate_challenge_leaderboard
    leaderboard = LeaderboardDevsnest::FeLeaderboard.new("#{slug}-lb").call
    leaderboard.delete_leaderboard
    best_submissions = FrontendChallengeScore.where(frontend_challenge_id: id)

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
    Rails.cache.fetch("frontend_challenge_#{id}") { fetch_files_s3('frontend-testcases', id.to_s) }
  end

  def self.count_solved(user_id)
    challenge_ids = FrontendChallengeScore.where(user_id: user_id).where('passed_test_cases = total_test_cases').pluck(:frontend_challenge_id)
    FrontendChallenge.where(id: challenge_ids, is_active: true).group(:topic).count
  end

  def self.split_by_topic
    where(is_active: true).group(:topic).count
  end

  private

  def expire_cache
    Rails.cache.delete("frontend_challenge_#{id}")
  end
end
