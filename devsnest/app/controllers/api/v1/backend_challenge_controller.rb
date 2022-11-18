# frozen_string_literal: true

module Api
  module V1
    # api for backend challenge
    class BackendChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show fetch_by_slug]

      def context
        {
          user: @current_user,
          action: params[:action]
        }
      end

      def fetch_by_slug
        challenge = BackendChallenge.find_by(slug: params[:slug])
        return render_not_found('challenge') if challenge.nil?

        render_success(challenge)
      end
    end
  end
end
