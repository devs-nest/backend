# frozen_string_literal: true

module Api
  module V1
    # SubmussUpvoteion Controller
    class UpvoteController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :destroy_auth, only: %i[destroy]

      def destroy_auth
        Upvote.find_by(id: params[:id])&.user == @current_user
      end
    end
  end
end
  