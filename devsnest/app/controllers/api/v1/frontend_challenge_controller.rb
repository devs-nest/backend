# frozen_string_literal: true

module Api
  module V1
    # allows challenges api calls to challenge resources
    class FrontendChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[show]
      before_action :callback_auth, only: %i[fetch_frontend_testcases]

      def context
        { user: @current_user,
          action: params[:action] }
      end

      def fetch_by_slug
        challenge = FrontendChallenge.find_by(slug: params[:slug])
        return render_not_found('challenge') if challenge.nil?

        user = User.find_by(username: params[:username])
        return render_not_found('user') if user.nil?

        previous_data = challenge.fetch_files_s3('user-fe-submission', "#{user.id}/#{challenge.id}")
        api_render(200, challenge.as_json.merge({ 'files': challenge.read_from_s3, 'previous_data': previous_data }))
      end

      def fetch_frontend_testcases
        challenge = FrontendChallenge.find_by(id: params[:id])
        return render_not_found({ message: 'challenge not found' }) if challenge.nil?

        content = $s3.get_object(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", key: challenge.testcases_path).body.read.to_s
        return render_not_found({ message: 'File not found' }) if content.empty?

        render_success({
                         'challenge_id': challenge.id,
                         'folder_name': challenge.folder_name,
                         'content': content
                       })
      end
    end
  end
end
