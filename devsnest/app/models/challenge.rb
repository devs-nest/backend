# frozen_string_literal: true

# algo challenge class
class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum content_type: %i[topic sub_topic]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearch queues heaps dynamicprogramming backtracking greedy maths]
  has_many :algo_submission
  has_many :algo_templates
  has_many :testcases
  has_many :company_challenge_mappings
  has_many :companies, through: :company_challenge_mappings
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug
  require 'challenge_templates'

  def put_testcase_in_s3(input_file, output_file, testcase)
    if testcase.present?
      input_filename = testcase.input_path.split('/')[-1].split('.')[0]
      output_filename = testcase.output_path.split('/')[-1].split('.')[0]
    else
      input_filename = "Q#{id}_#{name.parameterize.underscore}_#{testcases.count + 1}_hidden_in"
      output_filename = "Q#{id}_#{name.parameterize.underscore}_#{testcases.count + 1}_hidden_out"
    end
    input_path = "#{id}/input/#{input_filename}.txt"
    output_path = "#{id}/output/#{output_filename}.txt"
    $s3.put_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: input_path, body: input_file)
    $s3.put_object(bucket: "#{ENV['S3_PREFIX']}testcases", key: output_path, body: output_file)

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
end
