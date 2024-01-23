# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource for Sql Challenge Admin panel
      class SqlChallengeResource < JSONAPI::Resource
        attributes :name, :score, :difficulty, :is_active, :created_by, :user_id, :slug, :topic, :question_body, :expected_output,
                   :initial_sql_file
        key_type :string
        primary_key :slug

        def fetchable_fields
          if context[:action] == 'index'
            super - %i[question_body expected_output initial_sql_file is_active user_id created_by]
          else
            super
          end
        end
      end
    end
  end
end
