# frozen_string_literal: true

module Api
  module V1
    # Fe resource
    class FeSubmissionResource < JSONAPI::Resource
      attributes :user_id, :frontend_challenge_id, :source_code, :result, :question_type, :total_test_cases, :passed_test_cases, :is_submitted, :score
    end
  end
end
