# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Course Module Resource
      class CourseModuleResource < JSONAPI::Resource
        attributes :module_type, :is_paid, :timeline_status, :visibility, :created_at, :updated_at
      end
    end
  end
end
