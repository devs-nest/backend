# frozen_string_literal: true

module Api
  module V1
    class JobResource < JSONAPI::Resource
      attributes :title, :description, :salary, :job_type, :job_category, :location, :experience, :archived, :additional, :created_at, :updated_at, :organization_id, :organization_name

      def organization_name
        Organization.find(@model&.organization_id)&.name
      end

      def skills
        @model.skills.as_json
      end
    end
  end
end
