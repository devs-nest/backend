# frozen_string_literal: true

# a submission to an s3 bucket
class MinibootcampSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :frontend_question

  def self.post_to_s3(frontend_question_id, file_name, raw_code, user_id)
    bucket = "#{ENV['S3_PREFIX']}minibootcamp"
    key = "submissions/#{frontend_question_id}/#{user_id}#{file_name}.txt"

    $s3.put_object(bucket: bucket, key: key, body: raw_code)
  end
end
