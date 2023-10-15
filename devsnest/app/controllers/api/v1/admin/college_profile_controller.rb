# frozen_string_literal: true

module Api
  module V1
    module Admin
      # college profile admin controller
      class CollegeProfileController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :set_current_college_user, except: %i[create]
        before_action :college_admin_auth, only: %i[show iimport_students dashboard_details]

        def import_students
          file = params[:file]
          return render_error('File not found') unless file

          key = SecureRandom.hex(5) + '.csv'
          # temp name
          a = $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key, body: file)

          invalid_students = CollegeStudentImportWorker.perform_async(key, @current_college_user.college.id, params[:structure])

          api_render(201, { message: 'Students are being added' })
        end

        def dashboard_details
          batch = params[:batch]
          course = params[:course]
          branch = params[:branch]
          specialization = params[:specialization]
          section = params[:section]

          college = @current_college_user.college_profile.college
          college_structure_path = [batch, course, branch, specialization, section].compact.join('/')
          college_structure = CollegeStructure.where('college_id = ? AND name LIKE ?', college.id, "%#{college_structure_path}%")
          # college_profiles = college.college_profiles.where(college_structure_id: college_structure.pluck(:id))
          college_profiles = CollegeProfile.includes(:user).where(college_id: college.id, college_structure_id: college_structure.pluck(:id))

          data = []
          college_profiles.each do |college_profile|
            user = college_profile.user
            next if user.blank?

            data << college.activity
            data << user.get_dashboard_by_cache
          end
          render json: { data: data.as_json }
        end
      end
    end
  end
end
