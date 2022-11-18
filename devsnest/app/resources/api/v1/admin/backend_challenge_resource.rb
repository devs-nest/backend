# frozen_string_literal: true

module Api
  module V1
    module Admin
      # resource for backend challenge controller
      class BackendChallengeResource < JSONAPI::Resource
        attributes :name, :day_no, :topic, :difficulty, :slug, :question_body, :score, :is_active, :user_id, :course_curriculum_id

        filter :difficulty
        filter :topic
        filter :is_active
      end
    end
  end
end
