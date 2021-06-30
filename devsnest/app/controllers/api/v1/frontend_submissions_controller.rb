# frozen_string_literal: true

module Api
  module V1
    # frontend submission controller
    class FrontendSubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: [:create]

      def create
        user = @current_user
        question_unique_id = params['data']['attributes']['question_unique_id']
        content = Content.find_by(unique_id: question_unique_id)

        return render_error('User or Content not found') if user.nil? || content.nil?
 
        submission = FrontendSubmission.create_submission(user.id, content.id, params['data']['attributes']['submission_link'])
        render_success(submission.as_json.merge("type": 'submissions'))
      end
    end
  end
end
