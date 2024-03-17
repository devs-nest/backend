# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Course Module Resource
      class CourseModuleResource < JSONAPI::Resource
        attributes :name, :module_type, :is_paid, :timeline_status, :visibility, :created_at, :updated_at
        attributes :granularity_type
      end
    end
  end
end
