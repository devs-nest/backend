# frozen_string_literal: true

module Api
  module V1
    module Admin
      # college profile admin controller
      class CollegeProfileController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
        before_action :set_current_college_user, except: %i[create]

        def import_students
          file = params[:file]
          return render_error('File not found') unless file

          invalid_students = CollegeStudentImportWorker.perform_async(file, params[:college_id])
          api_render(201, { invalid_students: invalid_students })
        end

        def dashboard_details
          batch = params.dig(:data, :attributes, :batch) || nil
          course = params.dig(:data, :attributes, :course) || nil
          branch = params.dig(:data, :attributes, :branch) || nil
          specialization = params.dig(:data, :attributes, :specialization) || nil
          section = params.dig(:data, :attributes, :section) || nil

          college = @current_college_user.college_profile.college
          college_structure_path = [batch, course, branch, specialization, section].compact.join('/')
          college_structure = CollegeStructure.where('college_id = ? AND name LIKE ?', college.id, "#{college_structure_path}%")
          college_profiles = college.college_profiles.where(college_structure_id: college_structure.pluck(:id))

          data = []
          college_profiles.each do |college_profile|
            data << User.get_dashboard_by_cache(college_profile.user.id).as_json
          end
          render json: { data: data.as_json }
        end
      end
    end
  end
end
