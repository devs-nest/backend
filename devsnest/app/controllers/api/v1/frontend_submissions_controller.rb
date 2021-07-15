# frozen_string_literal: true

module Api
  module V1
    # frontend submission controller
    class FrontendSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :check_submission, only: %i[create]

      def check_submission
        content = Content.find_by(unique_id: params[:data][:attributes][:question_unique_id])
        return render_error('Content not found') unless content.present?

        submission = FrontendSubmission.find_by(user_id: @current_user.id, content_id: content.id)
        if submission.present?
          submission.update(submission_link: params[:data][:attributes][:submission_link])
          render_success(submission.as_json.merge('type': 'frontend_submissions'))
        end
        params[:data][:attributes][:content_id] = content.id
        params[:data][:attributes][:user_id] = @current_user.id
        params[:data][:attributes].delete 'question_unique_id'
      end
    end
  end
end
