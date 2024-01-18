# frozen_string_literal: true

module Api
  module V1
    # Resource for Sql Challenge
    class SqlChallengeResource < JSONAPI::Resource
      attributes :name, :score, :difficulty, :is_active, :created_by, :user_id, :slug, :topic, :question_body, :expected_output,
                 :initial_sql_file
      attributes :submission_status
      key_type :string
      primary_key :slug

      def fetchable_fields
        if context[:action] == 'index'
          super - %i[question_body expected_output initial_sql_file is_active user_id created_by]
        else
          super
        end
      end

      def submission_status
        user = context[:user]

        Rails.cache.fetch("user_sql_submission_#{user.id}_#{@model.id}") do
          sql_submission = SqlSubmission.find_by(user_id: user.id, sql_challenge_id: @model.id)
          if sql_submission.blank? || sql_submission.passed == false
            'unsolved'
          else
            'solved'
          end
        end
      end
    end
  end
end
