# frozen_string_literal: true

# Minibootcamp resourses
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic module]
  has_one :frontend_question

  def get_files_from_s3(path)
    $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}").contents.map(&:key)
  end
    
  def get_files_from_s3_with_prefix(path, prefix)
    $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}").contents.select { |file| file.key.include?(prefix) }.map(&:key)
  end

  def put_file_in_s3(path, file)
    $s3.put_object(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}", key: path, body: file)
  end

  def put_files_in_s3_with_prefix(path, prefix, files)
    files.each do |file|
      $s3.put_object(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}", key: "#{prefix}/#{file}", body: File.open("#{path}/#{file}"))
    end
  end
end
