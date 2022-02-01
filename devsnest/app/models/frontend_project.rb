# frozen_string_literal: true

# Project Model
class FrontendProject < ApplicationRecord
  validates :name, uniqueness: { scope: :user_id, case_sensitive: true }
  belongs_to :user
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]

  def self.post_to_s3(user_id, frontend_project_name, file_name, raw_code)
    bucket = "#{ENV['S3_PREFIX']}frontend-projects"
    key = "template_files/#{user_id}/#{frontend_project_name}#{file_name}.txt"

    $s3.put_object(bucket: bucket, key: key, body: raw_code)
  end
end
