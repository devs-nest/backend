# frozen_string_literal: true

module Api
  module V1
    # Be resource
    class BeSubmissionResource < JSONAPI::Resource
      attributes :user_id, :backend_challenge_id, :submitted_url, :status, :score, :total_test_cases, :passed_test_cases, :passed_test_cases_desc, :failed_test_cases_desc, :created_at, :updated_at,
                 :result
      filter :user_id
      filter :backend_challenge_id
    end
  end
end
