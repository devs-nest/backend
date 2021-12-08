# frozen_string_literal: true

module Api
  module V1
    class FrontendQuestionResource < JSONAPI::Resource
      attributes :module_id, :question_link
    end
  end
end
