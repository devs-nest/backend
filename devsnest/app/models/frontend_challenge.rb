# frozen_string_literal: true

# FrontendChallenge class
class FrontendChallenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum topic: %i[html css javascript react]
  has_many :frontend_challenge_scores
  has_many :assingment_questions
  belongs_to :user
  after_create :create_slug
  validates_uniqueness_of :name, :slug, case_sensitive: true
  before_save :expire_cache, if: :will_save_change_to_testcases_path?

  def create_slug
    update(slug: name.parameterize)
  end

  def put_test_cases(file, key)
    $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", key: key, body: file)
  end

  def remove_test_cases(key)
    $s3&.delete_object(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", key: key)
  end

  def input_case
    read_from_s3 input_key
  end

  def read_from_s3(key)
    Rails.cache.fetch(key, expires_in: 1.day) do
      $s3.get_object(bucket: "#{Rails.configuration.testcase_bucket_prefix}frontend-testcases", key: key).body.read
    end
  rescue StandardError
    nil
  end

  private

  def expire_cache
    Rails.cache.delete(input_key)
  end

  def input_key
    testcases_path.to_s
  end
end
