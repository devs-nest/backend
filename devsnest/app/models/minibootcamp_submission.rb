# frozen_string_literal: true

# == Schema Information
#
# Table name: minibootcamp_submissions
#
#  id                   :bigint           not null, primary key
#  is_solved            :boolean
#  submission_link      :string(255)
#  submission_status    :string(255)
#  frontend_question_id :integer
#  user_id              :integer
#
# Indexes
#
#  index_on_user_and_frontend_question  (user_id,frontend_question_id) UNIQUE
#
class MinibootcampSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_question, optional: true

  def self.post_to_s3(frontend_question_id, file_name, raw_code, user_id)
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    key = "submissions/#{frontend_question_id}/#{user_id}#{file_name}.txt"

    $s3&.put_object(bucket: bucket, key: key, body: raw_code)
  end
end
