module Api
  module V1
    module Admin
      class JobResource < JSONAPI::Resource
        attributes :organization_id, :user_id, :title, :description, :salary, :job_type, :job_category, :location, :experience, :archived, :additional, :created_at, :updated_at
      end
    end
  end
end