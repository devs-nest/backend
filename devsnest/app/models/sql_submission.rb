# frozen_string_literal: true

# Model for sql submissions
class SqlSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :sql_challenge
  after_commit :expire_cache

  def expire_cache
    Rails.cache.delete("user_sql_submission_#{user_id}_#{sql_challenge_id}")
  end
end
