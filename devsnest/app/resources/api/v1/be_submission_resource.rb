# frozen_string_literal: true

module Api
  module V1
    # Be resource
    class BeSubmissionResource < JSONAPI::Resource
      attributes :user_id, :backend_challenge_id, :submitted_url, :status, :score, :total_test_cases, :passed_test_cases
      filter :user_id
      paginator :paged
    end
  end
end
