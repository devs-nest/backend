# frozen_string_literal: true

module Api
  module V1
    class JobApplicationsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        job_applications = JobApplication.all.where(user_id: @current_user.id).order(updated_at: :desc)
        return render_error('No job applications found', 404) if job_applications.empty?

        render_success(job_applications)
      end
    end
  end
end
