# frozen_string_literal: true

# == Schema Information
#
# Table name: frontend_questions
#
#  id                :bigint           not null, primary key
#  active_path       :string(255)
#  hidden_files      :text(65535)
#  name              :string(255)
#  open_paths        :text(65535)
#  protected_paths   :text(65535)
#  question_markdown :text(65535)
#  show_explorer     :boolean
#  template          :integer
#
class FrontendQuestion < ApplicationRecord
  include MinibootcampHelper
  has_one :minibootcamp
  has_many :minibootcamp_submissions
  serialize :open_paths, Array
  serialize :protected_paths, Array
  serialize :hidden_files, Array
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]

  def self.post_to_s3(frontend_question_id, file_name, raw_code)
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    key = "template_files/#{frontend_question_id}#{file_name}.txt"

    $s3&.put_object(bucket: bucket, key: key, body: raw_code)
  end

  def template_files
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    prefix = "template_files/#{id}/"
    s3_files_to_json(bucket, prefix)
  end
end
