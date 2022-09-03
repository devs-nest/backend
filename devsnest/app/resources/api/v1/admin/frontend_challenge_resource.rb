# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    module Admin
      class FrontendChallengeResource < JSONAPI::Resource
        attributes :name, :day_no, :folder_name, :topic, :difficulty, :slug, :question_body, :score, :is_active, :user_id, :course_curriculum_id, :testcases_path, :hidden_files, :protected_paths, :open_paths,
                   :template, :active_path, :challenge_type, :files

        filter :difficulty
        filter :topic
        filter :is_active
        attributes :files

        def hidden_files
          return JSON.parse(@model.hidden_files) if @model.hidden_files.present?

          []
        end

        def protected_paths
          return JSON.parse(@model.protected_paths) if @model.protected_paths.present?

          []
        end

        def open_paths
          return JSON.parse(@model.open_paths) if @model.open_paths.present?

          []
        end

        def testcases_path
          return @model.testcases_path.sub(id.to_s, '') if @model.testcases_path.present?

          ''
        end

        def files
          FrontendChallenge.fetch_files(id, 'frontend-testcases', id.to_s)
        end

        def created_by
          @model&.user&.username
        end
      end
    end
  end
end
