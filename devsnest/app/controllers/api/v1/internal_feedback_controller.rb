# frozen_string_literal: true

module Api
  module V1
    # Class to create internal feedback
    class InternalFeedbackController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :check_feedback_count, only: %i[create]
      before_action :admin_auth, only: %i[update]

      def context
        {
          user: @current_user,
          fetch_user: params[:user_id]
        }
      end

      def check_feedback_count
        feedback_type = params[:data][:attributes][:feedback_type]
        count = InternalFeedback.where(user_id: @current_user.id).where(feedback_type: feedback_type).where(created_at: date_parser).count

        render_error({ message: 'You can Only Create 5 feedbacks in 1 day of this type' }) if count == 5

        params[:data][:attributes][:user_id] = @current_user.id
        params[:data][:attributes][:user_name] = @current_user.username
      end

      def date_parser
        Date.today.beginning_of_day..Date.today.end_of_day
      end
    end
  end
end
