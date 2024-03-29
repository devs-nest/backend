# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :score, :priority, :slug
      attributes :submission_status, :supported_languages
      filter :difficulty
      filter :topic
      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :company_id, apply: lambda { |records, value, _options|
        records.where(id: CompanyChallengeMapping.where(company_id: value.map(&:to_i)).pluck(:challenge_id))
      }

      paginator :paged

      def topic
        # Temporary fix for foundation questions formatting for frontend
        @model.topic == 'python_questions' ? 'python' : @model.topic
      end

      def self.records(options = {})
        if options[:context][:challenge_id].nil?
          super(options).where(is_active: true)
        else
          super(options)
        end
      end

      def submission_status
        user = context[:user]
        return 'signin to check submissions' if user.nil?

        Rails.cache.fetch("user_algo_submission_#{user.id}_#{@model.id}") do
          submission = user.user_challenge_scores.find_by(challenge_id: @model.id)
          if submission.blank?
            'unsolved'
          else
            submission.passed_test_cases == submission.total_test_cases ? 'solved' : 'attempted'
          end
        end
      end

      def supported_languages
        @model.supported_languages.select(:id, :name, :judge_zero_id, :language_description).as_json
      end
    end
  end
end
