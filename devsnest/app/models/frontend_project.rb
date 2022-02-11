# frozen_string_literal: true

# Project Model
class FrontendProject < ApplicationRecord
  validates :name, uniqueness: { scope: :user_id, case_sensitive: true }
  belongs_to :user
  after_create :create_slug
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]

  def create_slug
    update_attribute(:slug, name.parameterize)
  end

  def self.post_to_s3(user_id, frontend_project_slug, file_name, raw_code)
    bucket = "#{ENV['S3_PREFIX'] || 'Test'}frontend-projects"
    key = "template_files/#{user_id}/#{frontend_project_slug}#{file_name}.txt"

    $s3&.put_object(bucket: bucket, key: key, body: raw_code)
  end

  def template_files
    files = {}
    bucket = "#{ENV['S3_PREFIX']}frontend-projects"
    prefix = "template_files/#{user_id}/#{name}"

    s3_files = $s3_resource&.bucket(bucket)&.objects(prefix: prefix)&.collect(&:key) || []
    s3_files.each do |file|
      next unless file.end_with?('.txt')

      content = $s3&.get_object(bucket: bucket, key: file)&.body&.read
      file.slice! prefix
      file.slice! '.txt'

      files.merge!(Hash[file, content])
    end

    files
  end
end
