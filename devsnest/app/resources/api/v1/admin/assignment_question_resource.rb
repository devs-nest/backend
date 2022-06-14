# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class AssignmentQuestionResource < JSONAPI::Resource
        attributes :course_curriculum_id, :question_id, :question_type
        paginator :paged
      end
    end
  end
end
