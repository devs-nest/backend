# frozen_string_literal: true

module Api
  module V1
    class JobsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def fetch_by_slug
        job = Job.find_by(slug: params[:slug])
        return render_not_found if job.nil?

        skills = job.skills.map(&:name)
        job = (job.as_json).merge(skills: skills)
        render_success(job)
      end
    end
  end
end
