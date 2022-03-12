# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class ChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :score, :priority, :slug
      attributes :submission_status
      filter :difficulty
      filter :topic
      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :company_id, apply: lambda { |records, value, _options|
        records.where(id: CompanyChallengeMapping.where(company_id: value.map(&:to_i)).pluck(:challenge_id))
      }

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

        algo_submissions = user.algo_submissions.where(challenge_id: @model.id, is_submitted: true)
        return 'unsolved' if algo_submissions.empty?

        algo_submissions.where(status: 'Accepted', is_submitted: true).present? ? 'solved' : 'attempted'
      end
    end
  end
end
