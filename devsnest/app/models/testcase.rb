# frozen_string_literal: true

# == Schema Information
#
# Table name: testcases
#
#  id           :bigint           not null, primary key
#  input_path   :string(255)
#  is_sample    :boolean
#  output_path  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  challenge_id :integer
#
# Indexes
#
#  index_testcases_on_challenge_id_and_is_sample  (challenge_id,is_sample)
#
class Testcase < ApplicationRecord
  belongs_to :challenge
  after_commit :expire_cache

  def input_case
    read_from_s3 input_key
  end

  def output_case
    read_from_s3 output_key
  end

  def read_from_s3(key)
    Rails.cache.fetch(key, expires_in: 1.day) do
      $s3.get_object(bucket: "#{Rails.configuration.testcase_bucket_prefix}testcases", key: key).body.read
    end
  rescue StandardError
    nil
  end

  private

  def expire_cache
    Rails.cache.delete(input_key)
    Rails.cache.delete(output_key)
  end

  def input_key
    "#{challenge_id}/input/#{input_path}"
  end

  def output_key
    "#{challenge_id}/output/#{output_path}"
  end
end
