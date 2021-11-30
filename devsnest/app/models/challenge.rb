# frozen_string_literal: true

# algo challenge class
class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearch queues heaps dynamicprogramming backtracking greedy maths]
  has_many :algo_submission
  has_many :testcases
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug

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

    [input_filename, output_filename]
  end

  def create_slug
    update(slug: name.parameterize)
  end
end
