# frozen_string_literal: true

module Api
  module V1
    class CollegeStudentResource < JSONAPI::Resource
      attributes :name, :phone, :dob, :email, :parent_name, :parent_phone, :parent_email, :high_school_board, :high_school_name, :high_school_passing_year, :high_school_result,
                 :higher_education_type, :diploma_university_name, :diploma_passing_year, :diploma_result, :higher_secondary_board, :higher_secondary_school_name, :higher_secondary_passing_year,
                 :higher_secondary_result, :state, :higher_education_type, :phone_verified
    end
  end
end
