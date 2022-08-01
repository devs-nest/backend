# frozen_string_literal: true

module Api
  module V1
    # api for testing the population submissions
    class RunSubmissionResource < JSONAPI::Resource
      attributes :user_id, :challenge_id, :source_code, :language, :test_cases, :total_test_cases, :passed_test_cases, :status, :total_runtime, :total_memory
      attributes :score_achieved, :is_submitted

      def score_achieved
        challenge = @model.challenge
        testcases_count = challenge.testcases.count
        return 0 if testcases_count.zero?

        (@model.passed_test_cases / testcases_count.to_f) * challenge.score
      end

      def is_submitted
        false
      end
    end
  end
end
