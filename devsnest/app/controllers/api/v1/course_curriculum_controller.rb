# frozen_string_literal: true

module Api
  module V1
    # Course Curriculum Controller
    class CourseCurriculumController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :set_course_module
      before_action :verify_accessibility

      def context
        { user: @current_user }
      end

      private

      def set_course_module
        @course_module = CourseModule.find(params[:course_module_id])
      end

      def verify_accessibility
        return true if @course_module.visibility == "public_module"

        user_access = CourseModuleAccess.find_by(course_module_id: @course_module.id, accessible_id: @current_user.id, accessible_type: 'User')
        college_profile_user_ids = CollegeProfile.where(user_id: @current_user.id).pluck(:id)
        college_access = CourseModuleAccess.find_by(course_module_id: @course_module.id, accessible_id: college_profile_user_ids, accessible_type: 'College') if college_profile_user_ids
        return render_error('You do not have access to the given bootcamp.') if access_not_granted?(user_access) && access_not_granted?(college_access)
      end

      def access_not_granted?(data)
        data.nil? || data[:status] != 'granted'
      end
    end
  end
end
