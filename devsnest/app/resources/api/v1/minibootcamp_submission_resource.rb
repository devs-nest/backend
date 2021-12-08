# frozen_string_literal: true

module Api
  module V1
    class MinibootcampSubmissionResource < JSONAPI::Resource
      attributes :user_id, :frontend_question_id
    end
  end
end
