# frozen_string_literal: true

module Api
  module V1
    class JobApplicationsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :current_user_auth, only: %i[show]

      def index
        job_applications = JobApplication.all.where(user_id: @current_user.id).order(updated_at: :desc)
        return render_not_found('job_applications') if job_applications.blank?

        render_success({ job_applications: job_applications })
      end

      def current_user_auth
        user_id = JobApplication.find_by(id: params[:id])&.user_id
        render_unauthorized unless @current_user.id == user_id
      end
    end
  end
end
