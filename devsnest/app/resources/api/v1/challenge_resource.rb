# frozen_string_literal: true

module Api
  module V1
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :sample_test_cases

      def sample_test_cases
        challenge_id = context[:challenge_id] || @model.id
        tc = Testcase.where(challenge_id: challenge_id, is_sample: true)
        sample_inpf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/input/#{tc.input_path}")
        sample_outf = $s3.get_object(bucket: ENV['S3_PREFIX'] + 'testcases', key: "#{challenge_id}/output/#{tc.output_path}")

        tc_hash = Hash.new
        counter = 1
        tc.each do |testcase|
          tc_hash[counter] = {
            input: sample_inpf.body.read,
            output: sample_outpf.body.read
          }
          counter += 1
        end

        tc_hash
      end

      
    end
  end
end
