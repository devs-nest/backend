# frozen_string_literal: true

module Api
  module V1
    # allows challenges api calls to challenge resources
    class FrontendChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[fetch_by_slug index show]
      before_action :callback_auth, only: %i[fetch_frontend_testcases]

      def context
        { user: @current_user,
          params: params }
      end

      def fetch_by_slug
        challenge = FrontendChallenge.find_by(slug: params[:slug])
        return render_not_found('challenge') if challenge.nil?

        data = []
        files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", prefix: "#{challenge.id}/")
        files.contents.each do |file|
          data << { 'path' => file.key.to_s, 'content' => $s3.get_object(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", key: file.key).body.read.to_s }
        end
        api_render(200, challenge.as_json.merge({ 'files': data }))
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
