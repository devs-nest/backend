# frozen_string_literal: true

module Api
  module V1
    # college student controller
    class CollegeStudentsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def verify_phone
        college_student = CollegeStudent.find_or_create_by(user_id: @current_user.id)
        # update state if verification is success
        college_student.update!(state: 'personal_detail')
        render_success(college_student)
      end

      def personal_details
        college_student = @current_user.college_student
        return render_error('Complete the Previous steps') if college_student.nil? || college_student.state_before_type_cast < 1

        college_student.update!(personal_details_params.as_json.merge(state: 'education_detail'))
        render_success(college_student)
      end

      def education_details
        college_student = @current_user.college_student
        return render_error('Complete the Previous steps') if college_student.nil? || college_student.state_before_type_cast < 2

        data = college_student.state == 'education_detail' ? personal_details_params.as_json.merge(state: 'preview') : personal_details_params.as_json
        college_student.update!(data)
        render_success(college_student)
      end

      def show
        college_student = CollegeStudent.find_by(user_id: params[:id])
        render_success(college_student)
      end

      private

      def personal_details_params
        params.dig(:data, :attributes).permit(:name, :email, :dob, :parent_name, :parent_phone, :parent_email)
      end

      def education_params
        params.dig(:data, :attributes).permit(:high_school_board, :high_school_name, :high_school_passing_year, :high_school_result, :higher_education_type, :diploma_university_name,
                                              :diploma_passing_year, :diploma_result, :higher_secondary_board, :higher_secondary_school_name, :higher_secondary_passing_year,
                                              :higher_secondary_result)
      end
    end
  end
end
