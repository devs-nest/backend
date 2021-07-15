module Api
  module V1
    class FrontendSubmissionResource < JSONAPI::Resource
      attributes :user_id, :content_id, :submission_link, :status
    end
  end
end
