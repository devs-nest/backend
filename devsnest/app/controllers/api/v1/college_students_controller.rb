# frozen_string_literal: true

module Api
  module V1
    # college student controller
    class CollegeStudentsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :set_college_student, except: %i[show]

      def verify_phone
        return render_error('Not a College Student') if @college_student.nil?

        # update state if verification is success
        @college_student.update!(state: 'fill_pd')
        render_success(@college_student)
      end

      def personal_details
        return render_error('Complete the Previous steps') if @college_student.nil? || @college_student.state_before_type_cast < 1

        return render_unprocessable('Email Already Registered.') if CollegeStudent.exists?(email: personal_details_params[:email])

        @college_student.update!(personal_details_params.as_json.merge(state: 'fill_ed'))
        render_success(@college_student)
      end

      def education_details
        return render_error('Complete the Previous steps') if @college_student.nil? || @college_student.state_before_type_cast < 2

        data = @college_student.state == 'fill_ed' ? education_params.as_json.merge(state: 'preview') : education_params.as_json
        @college_student.update!(data)
        render_success(@college_student)
      end

      def preview
        return render_error('Complete the Previous steps') if @college_student.nil? || @college_student.state_before_type_cast < 3

        @college_student.update!(state: 'pay_reg_fee')
        render_success(@college_student)
      end

      def show
        college_student = CollegeStudent.find_by(user_id: params[:id])
        return render_not_found if college_student.nil?

        render_success(college_student)
      end

      private

      def personal_details_params
        params.dig(:data, :attributes).permit(:name, :email, :dob, :parent_name, :parent_phone, :parent_email, :gender)
      end

      def education_params
        params.dig(:data, :attributes).permit(:high_school_board, :high_school_name, :high_school_passing_year, :high_school_result, :higher_education_type, :diploma_university_name,
                                              :diploma_passing_year, :diploma_result, :higher_secondary_board, :higher_secondary_school_name, :higher_secondary_passing_year,
                                              :higher_secondary_result, :high_school_board_type, :higher_secondary_board_type, :coding_summary, coding_exp: [])
      end

      def set_college_student
        @college_student = @current_user.college_student
      end
    end
  end
end
