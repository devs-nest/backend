# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Course Resource
      class CourseResource < JSONAPI::Resource
        attributes :name, :archived
      end
    end
  end
end
