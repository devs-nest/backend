# frozen_string_literal: true

module Api
  module V1
    # BE submission controller
    class BeSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show index]
      before_action :current_user_auth, only: %i[create]

      def create
        backend_challenge_id = params.dig(:data, :attributes, :backend_challenge_id)
        submitted_url = params.dig(:data, :attributes, :submitted_url)
        backend_challenge = BackendChallenge.find_by_id(backend_challenge_id)
        user_id = params.dig(:data, :attributes, :user_id)
        return render_not_found({ message: 'Challenge Not Found' }) unless backend_challenge

        if backend_challenge.challenge_type == 'normal'
          return render_not_found({ message: 'No Testcases Found' }) unless backend_challenge.testcases_path.present?

          return render_error({ message: 'Invalid URI' }) unless BeSubmission.validate_uri(submitted_url)

          last_be_submission = BeSubmission.where(user_id: user_id, backend_challenge_id: backend_challenge_id).last
          return render_error({ message: 'Please wait for your last submission to be processed.' }) if last_be_submission.present? && last_be_submission.total_test_cases.zero?

          submission = BeSubmission.create(user_id: user_id, backend_challenge_id: backend_challenge_id, submitted_url: submitted_url)
          return api_render(201, submission)
        end

        options = {
          score: params.dig(:data, :attributes, :total_test_cases),
          passed_test_cases_desc: params.dig(:data, :attributes, :passed_test_cases_desc),
          passed_test_cases: params.dig(:data, :attributes, :passed_test_cases),
          failed_test_cases_desc: params.dig(:data, :attributes, :failed_test_cases_desc),
          total_test_cases: params.dig(:data, :attributes, :total_test_cases),
          user_id: user_id,
          backend_challenge_id: backend_challenge_id
        }

        submission = BeSubmission.create(options)
        api_render(201, submission)
      end
    end
  end
end
