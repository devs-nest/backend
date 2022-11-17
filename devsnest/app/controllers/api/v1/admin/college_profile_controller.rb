# frozen_string_literal: true

module Api
  module V1
    module Admin
      # college profile admin controller
      class CollegeProfileController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def import_students
          file = params[:file]
          return render_error('File not found') unless file

          invalid_students = CollegeStudentImportWorker.perform_async(file, params[:college_id])
          api_render(201, { invalid_students: invalid_students })
        end
      end
    end
  end
end
