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

      def index
        resource_records = CourseCurriculum.where(course_module_id: @course_module&.id)
        resources = resource_records.map { |record| CourseCurriculumResource.new(record, { user: @current_user }) }
        extra_data = {
          granularity_type: @course_module&.granularity_type
        }
        render json: JSONAPI::ResourceSerializer.new(CourseCurriculumResource).serialize_to_hash(resources).merge!(extra_data)
      end

      private

      def set_course_module
        course_module_id = params[:course_module_id] || params.dig(:filter, :course_module_id)
        @course_module = CourseModule.find_by_id(course_module_id)
        return false if @course_module.blank?
      end

      def verify_accessibility
        return true if @course_module.visibility == 'public_module'

        user_access = CourseModuleAccess.find_by(course_module_id: @course_module.id, accessor: @current_user)
        college_ids = CollegeProfile.where(user_id: @current_user.id).pluck(:college_id)
        college_access = CourseModuleAccess.find_by(course_module_id: @course_module.id, accessor_id: college_ids, accessor_type: 'College') if college_ids
        return render_error('You do not have access to the given bootcamp.') if access_not_granted?(user_access) && access_not_granted?(college_access)
      end

      def access_not_granted?(data)
        data.nil? || data[:status] != 'granted'
      end
    end
  end
end
