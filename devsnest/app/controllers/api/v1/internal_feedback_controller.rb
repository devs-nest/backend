# frozen_string_literal: true

module Api
  module V1
    # Class to create internal feedback with cooldown of 7 days
    class InternalFeedbackController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :check_feedback, only: %i[create]
      before_action :admin_auth, only: %i[update]

      def context
        {
          user: @current_user,
          fetch_user: params[:user_id]
        }
      end

      def check_feedback
        previous_feedback = InternalFeedback.where(user_id: @current_user.id).order(updated_at: :asc).last
        threshold_date = Date.today - 7.days
        error_message = 'Active cooldown for submitting new feedback : '
        if previous_feedback.present? && previous_feedback.updated_at >= threshold_date
          render_error({ message: "#{error_message}#{(previous_feedback.updated_at.to_date - threshold_date).to_i} days" })
        end
        params[:data][:attributes][:user_id] = @current_user.id
      end
    end
  end
end
