# frozen_string_literal: true

module Api
  module V1
    class CollegeInviteController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :set_current_college_user
      before_action :college_admin_auth, only: %i[index]
      before_action :check_college_verification
      before_action :check_id, only: %i[index]

      def context
        {college_id: params[:college_id], department: params[:department]}
      end

      def check_id
        return true if params[:college_id].present?

        render_forbidden
      end
    end
  end
end