# frozen_string_literal: true

module Api
  module V1
    class FrontendSubmissionResource < JSONAPI::Resource
      attributes :user_id, :content_id, :submission_link
    end
  end
end
