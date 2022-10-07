# frozen_string_literal: true

module Api
  module V1
    class OrganizationResource < JSONAPI::Resource
      attributes :name, :description, :slug, :website, :logo_banner, :logo, :heading, :created_at, :updated_at, :jobs_count, :jobs

      def jobs_count
        @model.jobs.count
      end

      def jobs
        @model.jobs.as_json
      end
    end
  end
end
