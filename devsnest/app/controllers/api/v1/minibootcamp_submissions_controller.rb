# frozen_string_literal: true

module Api
  module V1
    # minibootcamp submission controller
    class MinibootcampSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[show index create update]
      before_action :create_submission, only: %i[create update]

      def context
        {
          current_user: @current_user
        }
      end

      def create_submission
        frontend_question_id = params.dig(:data, :attributes, :frontend_question_id)

        files = params.dig(:data, :attributes, :files) || {}
        files.each do |filename, filecontent|
          MinibootcampSubmission.post_to_s3(frontend_question_id, filename, filecontent, @current_user.id)
        end

        params[:data][:attributes].delete 'files'
      end
    end
  end
end
