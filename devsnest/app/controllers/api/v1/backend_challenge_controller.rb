# frozen_string_literal: true

module Api
  module V1
    # api for backend challenge
    class BackendChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index show]

      def context
        {
          user: @current_user,
          action: params[:action]
        }
      end
    end
  end
end
