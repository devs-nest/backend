# frozen_string_literal: true

module Api
  module V1
    # admin methods
    class AdminController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :admin_auth

      def onboard_details
        @onboards = User.where('created_at >= :span and is_discord_form_filled', span: 2.weeks.ago, is_discord_form_filled: true)
        response.headers['Content-Type'] = 'text/csv; charset=UTF-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=onboard_results_#{Date.current}.csv"
        render plain: @onboards.to_csv
      end

      def feedback_details
        @feedbacks = InternalFeedback.where(is_resolved: false)
        response.headers['Content-Type'] = 'text/csv; charset=UTF-8; header=present'
        response.headers['Content-Disposition'] = "attachment; filename=feedback_results_#{Date.current}.csv"
        render plain: @feedbacks.to_csv
      end
    end
  end
end
