# frozen_string_literal: true

module Api
  module V1
    # allows challenges api calls to challenge resources
    class ChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[submission]

      def context
        { challenge_id: params[:id] }
      end

      def submissions
        challenge_id = params[:id]
        api_render(200, { id: challenge_id, type: 'challenge', submissions: @current_user.algo_submission.where(challenge_id: challenge_id, is_submitted: true) })
      end
    end
  end
end
