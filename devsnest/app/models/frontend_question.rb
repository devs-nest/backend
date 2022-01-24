# frozen_string_literal: true

# frontend submission model
class FrontendQuestion < ApplicationRecord
  has_one :minibootcamp
  has_many :minibootcamp_submissions
  serialize :open_paths, Array
  serialize :protected_paths, Array
  serialize :hidden_files, Array
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]

  def self.post_to_s3(frontend_question_id, file_name, raw_code)
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    key = "template_files/#{frontend_question_id}#{file_name}.txt"

    $s3.put_object(bucket: bucket, key: key, body: raw_code)
  end

  def template_files
    files = {}
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    prefix = "template_files/#{self.id}/"

    s3_files = $s3_resource.bucket(bucket).objects(prefix: prefix).collect(&:key)
    s3_files.each do |file|
      next unless file.end_with?(".txt")
      
      content = $s3.get_object(bucket: bucket, key: file).body.read
      file.slice! prefix
      file.slice! ".txt"
      
      files.merge!(Hash[file, content])
    end

    files
  end
end
