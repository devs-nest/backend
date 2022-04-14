# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CollegeFormResource < JSONAPI::Resource
        attributes :user_id, :tpo_or_faculty_name, :college_name, :faculty_position, :email, :phone_number
      end
    end
  end
end
