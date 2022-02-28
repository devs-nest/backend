# frozen_string_literal: true

module Api
  module V1
    # api for testing the population submissions
    class AlgoSubmissionResource < JSONAPI::Resource
      attributes :user_id, :challenge_id, :source_code, :language, :test_cases, :total_test_cases, :passed_test_cases, :is_submitted, :status, :total_runtime, :total_memory
      attributes :score_achieved, :next_question

      def next_question
        return nil if @model.status != "Accepted"
        topic = @model.challenge.topic 
        # TODO
      end

      def score_achieved
        testcases_count = @model.challenge.testcases.count
        return 0 if testcases_count.zero?

        (@model.passed_test_cases / testcases_count.to_f) * @model.challenge.score
      end
    end
  end
end
