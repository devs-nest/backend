# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :sample_test_cases, :score, :priority
      filter :difficulty
      filter :topic

      def sample_test_cases
        challenge_id = context[:challenge_id] || @model.id
        tc = Testcase.where(challenge_id: challenge_id, is_sample: true)

        tc_arr = []
        counter = 1
        tc.each do |testcase|
          begin
            sample_inpf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/input/#{testcase.input_path}")
            sample_outf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/output/#{testcase.output_path}")
          rescue StandardError
            tc_arr << {}
          else
            tc_temp =
              {
                counter: {
                  input: Base64.encode64(sample_inpf.body.read),
                  output: Base64.encode64(sample_outf.body.read)
                }
              }
            tc_arr << tc_temp
          end
          counter += 1
        end

        tc_arr
      end
    end
  end
end
