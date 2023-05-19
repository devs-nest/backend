# frozen_string_literal: true

module Api
  module V1
    # college student controller
    class CollegeStudentsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      # 0: normal_user, 1: personal_details_saved(college-student), 2: education-detail-saved

      def personal_details
        college_student = CollegeStudent.find_or_create_by(user_id: @current_user.id)
        college_student.update!(personal_details_params)
        college_student.update!(pd_detail: true)
        @current_user.update!(is_college_student: true)
        api_render(201, college_student)
      end

      def education_details
        college_student = @current_user.college_student
        return render_not_found('college_student') if college_student.nil?

        college_student.update!(education_params)
        college_student.update!(ed_detail: true)
        api_render(200, college_student)
      end

      private

      def personal_details_params
        params.dig(:data, :attributes).permit(:name, :email, :phone, :dob, :parent_name, :parent_phone, :parent_email)
      end

      def education_params
        params.dig(:data, :attributes).permit(:high_school_board, :high_school_name, :high_school_passing_year, :high_school_result, :higher_education_type, :diploma_university_name,
                                              :diploma_passing_year, :diploma_result, :higher_secondary_board, :higher_secondary_school_name, :higher_secondary_passing_year, :higher_secondary_result)
      end
    end
  end
end
