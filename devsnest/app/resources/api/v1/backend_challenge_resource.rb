# frozen_string_literal: true

module Api
  module V1
    # resource for Backend challenges
    class BackendChallengeResource < JSONAPI::Resource
      attributes :name, :day_no, :topic, :difficulty, :slug, :question_body, :score, :is_active, :user_id, :course_curriculum_id, :testcases_path
      attributes :submission_status
      filter :difficulty
      filter :topic
      filter :is_active
      # attributes :files, :previous_data

      def self.records(options = {})
        if options[:context][:action] == 'index'
          super(options).where(is_active: true)
        else
          super(options)
        end
      end

      def fetchable_fields
        if context[:action] == 'index'
          %i[id name topic difficulty slug score submission_status]
        else
          super
        end
      end

      def testcases_path
        return @model.testcases_path.sub(id.to_s, '') if @model.testcases_path.present? && context[:action] == 'show'

        ''
      end

      # def files
      #   context[:action] == 'show' ? @model.read_from_s3 : []
      # end

      def submission_status
        user = context[:user]
        return 'signin to check submissions' if user.nil?

        submission = user.backend_challenge_scores.find_by(backend_challenge_id: @model.id)
        return 'unsolved' if submission.blank?

        submission.passed_test_cases == submission.total_test_cases ? 'solved' : 'attempted'
      end

      # def previous_data
      #   context[:action] == 'show' ? @model.fetch_files_s3('user-fe-submission', "#{context[:user].id}/#{id}") : []
      # end
    end
  end
end
