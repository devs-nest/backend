# frozen_string_literal: true

# == Schema Information
#
# Table name: challenges
#
#  id                   :bigint           not null, primary key
#  content_type         :integer
#  difficulty           :integer
#  input_format         :json
#  is_active            :boolean          default(FALSE)
#  name                 :string(255)
#  output_format        :json
#  priority             :integer
#  question_body        :text(65535)
#  score                :integer          default(0)
#  slug                 :string(255)
#  tester_code          :text(65535)
#  topic                :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  parent_id            :string(255)
#  unique_id            :string(255)
#  user_id              :integer
#
# Indexes
#
#  index_challenges_on_slug  (slug) UNIQUE
#
class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum content_type: %i[topic sub_topic]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearch queues heaps dynamicprogramming backtracking greedy maths]
  has_many :algo_submissions
  has_many :run_submissions
  has_many :algo_templates
  has_many :testcases
  has_many :company_challenge_mappings
  has_many :companies, through: :company_challenge_mappings
  has_many :user_challenge_scores
  has_many :room_best_submissions
  belongs_to :user
  has_many :assingment_questions
  after_create :create_slug
  validates_uniqueness_of :name, :slug, case_sensitive: true
  before_save :regenerate_challenge_leaderboard, if: :will_save_change_to_score?
  # before_update :re_evaluate_user_scores, if: :will_save_change_to_score?
  before_update :recalculate_user_scores, if: :will_save_change_to_is_active?
  after_save :remove_saved_templates

  scope :active, -> { where(is_active: true) }
  Language.all.each do |language|
    require "algo_templates/#{language.name}"
  end

  def fetch_sample_test_cases
    challenge_id = id
    tc = Testcase.where(challenge_id: challenge_id, is_sample: true)

    tc_hash = { sample_test_cases: {} }
    counter = 1
    tc.each do |testcase|
      begin
        sample_inpf = $s3.get_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: "#{challenge_id}/input/#{testcase.input_path}")
        sample_outf = $s3.get_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: "#{challenge_id}/output/#{testcase.output_path}")
      rescue StandardError
        tc_hash['error'] = 'An error occurred.'
      else
        tc_hash[:sample_test_cases][counter] = {
          input: Base64.encode64(sample_inpf.body.read),
          output: Base64.encode64(sample_outf.body.read)
        }
      end
      counter += 1
    end

    tc_hash
  end

  def put_testcase_in_s3(input_file, output_file, testcase)
    if testcase.present?
      input_filename = testcase.input_path
      output_filename = testcase.output_path
    else
      input_filename = "Q#{id}_#{name.parameterize.underscore}_#{(testcases&.last&.id || 0) + 1}_hidden_in"
      output_filename = "Q#{id}_#{name.parameterize.underscore}_#{(testcases&.last&.id || 0) + 1}_hidden_out"
    end
    input_path = "#{id}/input/#{input_filename}.txt"
    output_path = "#{id}/output/#{output_filename}.txt"
    $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: input_path, body: input_file)
    $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: output_path, body: output_file)

    ["#{input_filename}.txt", "#{output_filename}.txt"]
  end

  def create_slug
    update(slug: name.parameterize)
  end

  def add_companies(company_names)
    company_names.each do |company_name|
      company = Company.find_by(name: company_name)
      next if company.nil?

      CompanyChallengeMapping.create(challenge_id: id, company_id: company.id)
    end
  end

  def delete_companies(company_names)
    company_names.each do |company_name|
      company = Company.find_by(name: company_name)
      next if company.nil?

      CompanyChallengeMapping.find_by(challenge_id: id, company_id: company.id).destroy
    end
  end

  def create_template(language)
    not_implemented = {
      'tree': {
      }
    }
    return if input_format.nil? || output_format.nil? || not_implemented.dig(topic.to_sym, language[1].to_sym)

    template_gen =
      case language[1]
      when 'python3'
        Templates::Python3.new(input_format, output_format, topic)
      when 'cpp'
        Templates::CPP.new(input_format, output_format, topic)
      when 'java'
        Templates::Java.new(input_format, output_format, topic)
      when 'javascript'
        Templates::JavaScript.new(input_format, output_format, topic)
      end
    template = template_gen.build if template_gen.present?

    AlgoTemplate.create(challenge_id: id, language_id: language[0], head: template[:head], body: template[:body], tail: template[:tail]) if template.present? # FIX
    template
  end

  def is_solved?(user)
    algo_submissions.where(user_id: user.id, status: 'Accepted').present?
  end

  def self.split_by_difficulty
    where(is_active: true).group(:difficulty).count
  end

  def self.count_solved(user_id)
    challenge_ids = UserChallengeScore.where(user_id: user_id).where('passed_test_cases = total_test_cases').pluck(:challenge_id)
    Challenge.where(id: challenge_ids, is_active: true).group(:difficulty).count
  end

  def generate_leaderboard
    LeaderboardDevsnest::AlgoLeaderboard.new("#{slug}-lb").call
  end

  def regenerate_challenge_leaderboard
    # LeaderboardDevsnest::AlgoLeaderboard.new("#{slug}-lb").call.delete_leaderboard
    leaderboard = LeaderboardDevsnest::AlgoLeaderboard.new("#{slug}-lb").call
    leaderboard.delete_leaderboard
    best_submissions = UserChallengeScore.where(challenge_id: id)

    best_submissions.each do |submission|
      calc_score = score * (submission.passed_test_cases / submission.total_test_cases.to_f)
      submission.update(score: calc_score)
      leaderboard.rank_member(submission.user.username, calc_score)
    end
  end

  def self.rerank_member(user, new_username)
    previous_username = user.username

    best_submissions = user.user_challenge_scores

    best_submissions.each do |submission|
      leaderboard = LeaderboardDevsnest::AlgoLeaderboard.new("#{submission.challenge.slug}-lb").call
      leaderboard.remove_member(previous_username)
      leaderboard.rank_member(new_username, submission.challenge.score * (submission.passed_test_cases / submission.total_test_cases))
    end
  end

  def recalculate_user_scores
    UserScoreUpdate.perform_async(id, 'dsa')
  end

  def remove_saved_templates
    AlgoTemplate.where(challenge_id: id).destroy_all
  end
end

# Regenerate Leaderboard
#
# User.update_all(score: 0)
# challenge_ids = Challenge.where(id: challenge_ids, is_active: true)
# User.each do |u|
#   all_user_subs_score = UserChallengeScore.where(user: u.id, challenge_id: challenge_ids).sum {|a| a.score || 0}
#   u.update(score: all_user_subs_score)
#   main_lb = LeaderboardDevsnest::Initializer::LB
#   main_lb.rank_member(u.username, u.score || 0)
# end
