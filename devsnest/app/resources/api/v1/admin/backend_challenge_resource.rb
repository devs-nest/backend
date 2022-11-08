# frozen_string_literal: true

module Api
  module V1
    module Admin
      # resource for backend challenge controller
      class BackendChallengeResource < JSONAPI::Resource
        attributes :name, :day_no, :topic, :difficulty, :slug, :question_body, :score, :is_active, :user_id, :course_curriculum_id, :testcases_path

        filter :difficulty
        filter :topic
        filter :is_active
        # attributes :files

        def testcases_path
          return @model.testcases_path.sub(id.to_s, '') if @model.testcases_path.present? && context[:action] == 'show'

          ''
        end

        # def files
        #   context[:action] == 'show' ? @model.read_from_s3 : []
        # end

        # def created_by
        #   @model&.user&.username
        # end
      end
    end
  end
end
