# frozen_string_literal: true

module Api
  module V1
    # Course Curriculum Controller
    class CourseCurriculumController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :set_course_id
      before_action :verify_accessibility

      def context
        { user: @current_user }
      end

      private

      def set_course_id
        if params[:action] == 'index'
          return render_error('course_name is required inside filter') if params.require(:filter).class == String

          params.require(:filter).require(:course_name)
          @course_id = Course.find_by(name: course_name)&.id
        elsif params[:action] == 'show'
          @course_id = params[:id]
        end
      end

      def verify_accessibility
        # TODO: flow for the college_access
        user_access = BootcampAccess.find_by(course_id: @course_id, accessible_id: @current_user.id, accessible_type: 'User')
        return render_error('You do not have access to the given bootcamp.') if user_access.nil? || user_access[:status] != 'granted'
      end
    end
  end
end
