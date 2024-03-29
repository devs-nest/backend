# frozen_string_literal: true

module Api
  module V1
    # discussion controller
    class DiscussionController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, except: %i[index show]
      before_action :destroy_auth, only: %i[destroy]
      before_action :change_slug_to_id, only: %i[show]

      def context
        { user: @current_user }
      end

      def destroy_auth
        Discussion.find_by(id: params[:id])&.user == @current_user || @current_user.admin? ? true : render_unauthorized
      end

      def change_slug_to_id
        discussion_thread = Discussion.find_by_slug(params[:id].to_s)
        return render_not_found if discussion_thread.blank?

        params[:id] = discussion_thread.id
      end
    end
  end
end
