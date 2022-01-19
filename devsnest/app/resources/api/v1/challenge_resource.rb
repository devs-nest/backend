# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :sample_test_cases, :score, :priority, :slug
      filter :difficulty
      filter :topic
      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :company_id, apply: lambda { |records, value, _options|
        records.where(id: CompanyChallengeMapping.where(company_id: value[0].to_i).pluck(:challenge_id))
      }

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

      def self.records(options = {})
        if options[:context][:challenge_id].nil?
          super(options).where(is_active: true)
        else
          super(options)
        end
      end
    end
  end
end
