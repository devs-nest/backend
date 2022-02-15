# frozen_string_literal: true

# algo challenge class
class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum content_type: %i[topic sub_topic]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearch queues heaps dynamicprogramming backtracking greedy maths]
  has_many :algo_submissions
  has_many :algo_templates
  has_many :testcases
  has_many :company_challenge_mappings
  has_many :companies, through: :company_challenge_mappings
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug
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
        sample_inpf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/input/#{testcase.input_path}")
        sample_outf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/output/#{testcase.output_path}")
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
      input_filename = testcase.input_path&.split('/') & [-1]&.split('.') & [0]
      output_filename = testcase.output_path&.split('/') & [-1]&.split('.') & [0]
    else
      input_filename = "Q#{id}_#{name.parameterize.underscore}_#{testcases.count + 1}_hidden_in"
      output_filename = "Q#{id}_#{name.parameterize.underscore}_#{testcases.count + 1}_hidden_out"
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
    return if input_format.nil? || output_format.nil?

    template_gen =
      case language[1]
      when 'python3'
        Templates::Python3.new(input_format, output_format)
      when 'cpp'
        Templates::CPP.new(input_format, output_format)
      when 'java'
        Templates::Java.new(input_format, output_format)
      when 'javascript'
        Templates::JavaScript.new(input_format, output_format)
      end
    template = template_gen.build if template_gen.present?

    AlgoTemplate.create(challenge_id: id, language_id: language[0], head: template[:head], body: template[:body], tail: template[:tail]) if template.present? # FIX
    template
  end

  def self.split_by_difficulty
    where(is_active: true).group(:difficulty).count
  end

  def self.count_solved(user_id)
    challenge_ids = AlgoSubmission.where(user_id: user_id, is_submitted: true, status: 'Accepted').pluck(:challenge_id)
    Challenge.where(id: challenge_ids).group(:difficulty).count
  end
end
