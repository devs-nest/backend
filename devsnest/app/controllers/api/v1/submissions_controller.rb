# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :discord_authorize

      def create
        discord_id = params['data']['attributes']['discord_id']
        question_unique_id = params['data']['attributes']['question_unique_id']
        user = User.find_by(discord_id: discord_id)
        content = Content.find_by(unique_id: question_unique_id)
        choice = params['data']['attributes']['status']

        return render_error('User or Content not found') if user.nil? || content.nil?

        submission = Submission.create_submission(user.id, content.id, choice)
        render_success(submission.as_json.merge("type": 'submissions'))
      end
    end
  end
end
