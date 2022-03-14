# frozen_string_literal: true

module Api
  module V1
    class DiscussionController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :destroy_auth, only: %i[destroy]

      def context
        { user: @current_user }
      end

      def destroy_auth
        Discussion.find_by(id: params[:id])&.user == @current_user || @current_user.admin?
      end
    end
  end
end
