# frozen_string_literal: true

module Api
  module V1
    # resource for Backend challenges
    class BackendChallengeResource < JSONAPI::Resource
      attributes :name, :day_no, :topic, :difficulty, :slug, :question_body, :score, :is_active, :user_id, :course_curriculum_id, :testcases_path, :hidden_files, :protected_paths, :open_paths,
                 :template, :active_path, :challenge_type
      attributes :submission_status
      filter :difficulty
      filter :topic
      filter :is_active
      attributes :files, :previous_data

      paginator :paged

      def self.records(options = {})
        if options[:context][:action] == 'index'
          super(options).where(is_active: true, is_project: false)
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

      def hidden_files
        return JSON.parse(@model.hidden_files) if @model.hidden_files.present? && context[:action] == 'show'

        []
      end

      def protected_paths
        return JSON.parse(@model.protected_paths) if @model.protected_paths.present? && context[:action] == 'show'

        []
      end

      def open_paths
        return JSON.parse(@model.open_paths) if @model.open_paths.present? && context[:action] == 'show'

        []
      end

      def files
        context[:action] == 'show' ? @model.fetch_files_s3('backend-testcases', @model.id.to_s) : []
      end

      def submission_status
        user = context[:user]
        return 'signin to check submissions' if user.nil?

        Rails.cache.fetch("user_be_submission_#{user.id}_#{@model.id}") do
          submission = user.backend_challenge_scores.find_by(backend_challenge_id: @model.id)
          if submission.blank?
            'unsolved'
          else
            submission.passed_test_cases == submission.total_test_cases ? 'solved' : 'attempted'
          end
        end
      end

      def previous_data
        context[:action] == 'show' ? @model.fetch_files_s3('user-be-submission', "#{context[:user].id}/#{id}") : {}
      end
    end
  end
end
