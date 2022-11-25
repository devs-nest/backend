# frozen_string_literal: true

module Api
  module V1
    # BE submission controller
    class BeSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show index]
      before_action :current_user_auth, only: %i[create]

      def create
        backend_challenge_id = params[:data][:attributes][:backend_challenge_id]
        submitted_url = params[:data][:attributes][:submitted_url]
        backend_challenge = BackendChallenge.find_by_id(backend_challenge_id)
        return render_error({ message: 'challenge not found' }) unless backend_challenge

        return render_error({ message: 'no testcases found' }) unless backend_challenge.testcases_path.present?

        return render_error({ message: 'invalid uri' }) unless BeSubmission.validate_uri(submitted_url)

        submission = BeSubmission.create(user_id: params[:data][:attributes][:user_id], backend_challenge_id: backend_challenge_id, submitted_url: submitted_url)
        api_render(201, submission)
      end
    end
  end
end
