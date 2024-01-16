# frozen_string_literal: true

module Api
  module V1
    class SqlChallengeResource < JSONAPI::Resource
      attributes :title, :score, :difficulty, :is_active, :created_by, :user_id, :slug, :topic, :question_body, :status, :expected_output,
                 :initial_sql_file
    end
  end
end
