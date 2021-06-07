# frozen_string_literal: true

module Api
  module V1
    class SubmissionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: [:create]

      def create
        if @bot.present?
          discord_id = params['data']['attributes']['discord_id']
          user = User.find_by(discord_id: discord_id)

          return render_error('user_not_active_web') if user.nil? || !user.web_active
        else
          user = @current_user
        end

        question_unique_id = params['data']['attributes']['question_unique_id']
        content = Content.find_by(unique_id: question_unique_id)
        choice = params['data']['attributes']['status']

        return render_error('User or Content not found') if user.nil? || content.nil?
        submission = Submission.create_submission(user.id, content.id, choice)
        return render_success(submission.as_json.merge("type": 'submissions'))
      end
    end
  end
end
