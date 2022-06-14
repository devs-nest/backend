# frozen_string_literal: true

module Api
  module V1
    module Admin
      # AssignmentQuestion Controller for Admin
      class AssignmentQuestionController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def add_assignment_questions
          course_curriculum_id = params[:data][:course_curriculum_id]
          return render_not_found if course_curriculum_id.blank?

          AssignmentQuestion.where(course_curriculum_id: course_curriculum_id).destroy_all
          all_questions = params[:data][:questions_data]
          all_questions.each do |question|
            AssignmentQuestion.create!(course_curriculum_id: course_curriculum_id, question_id: question[:id], question_type: question[:type])
          rescue
            return render_error('Some Error occurred')
          end
          render_success({ message: 'Questions Added Succesfully!' })
        end
      end
    end
  end
end
