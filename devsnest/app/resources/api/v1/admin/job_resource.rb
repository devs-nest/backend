# frozen_string_literal: true

module Api
  module V1
    module Admin
      class JobResource < JSONAPI::Resource
        attributes :organization_id, :user_id, :title, :description, :salary, :job_type, :job_category, :location, :experience, :archived, :additional, :skills, :organization, :created_at, :updated_at

        def organization
          @model.organization.as_json
        end

        def skills
          @model.skills.as_json
        end
      end
    end
  end
end
