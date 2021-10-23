# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :sample_test_cases

      def sample_test_cases
        tc = Testcase.where(challenge_id: context[:challenge_id] || @model.id, is_sample: true)

        tc_hash = {}
        counter = 1
        tc.each do |testcase|
          tc_hash[counter] = {
            input: testcase.input_path,
            output: testcase.output_path
          }
          counter += 1
        end

        tc_hash
      end
    end
  end
end
