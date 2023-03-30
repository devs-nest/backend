# frozen_string_literal: true

module Api
  module V1
    module Admin
      # resource for backend challenge controller
      class BackendChallengeResource < JSONAPI::Resource
        attributes :name, :day_no, :topic, :difficulty, :slug, :question_body, :score, :is_active, :is_project, :user_id, :course_curriculum_id, :challenge_type,
                   :hidden_files, :protected_paths, :open_paths, :template, :active_path

        filter :difficulty
        filter :topic
        filter :is_active
        attributes :files

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

        def created_by
          @model&.user&.username
        end
      end
    end
  end
end
