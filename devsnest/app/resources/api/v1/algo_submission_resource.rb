# frozen_string_literal: true

module Api
  module V1
    class AlgoSubmissionResource < JSONAPI::Resource
      attributes :user_id, :challenge_id, :source_code, :language, :test_cases, :total_test_cases, :passed_test_cases, :is_submitted, :status, :total_runtime, :total_memory
      attributes :score_achieved

      def score_achieved
        (@model.passed_test_cases * @model.challenge.testcases.count) / @model.challenge.score
      end
    end
  end
end
