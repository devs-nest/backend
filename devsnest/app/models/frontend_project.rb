# frozen_string_literal: true

# == Schema Information
#
# Table name: frontend_projects
#
#  id         :bigint           not null, primary key
#  name       :string(255)
#  public     :boolean          default(TRUE)
#  slug       :string(255)
#  template   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_frontend_projects_on_user_id  (user_id)
#  index_projects_on_user_id_and_name  (user_id,name) UNIQUE
#
class FrontendProject < ApplicationRecord
  include MinibootcampHelper
  validates_uniqueness_of :name, case_sensitive: true, scope: :user_id
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
    bucket = "#{ENV['S3_PREFIX']}frontend-projects"
    prefix = "template_files/#{user_id}/#{name}"

    s3_files_to_json(bucket, prefix)
  end
end
