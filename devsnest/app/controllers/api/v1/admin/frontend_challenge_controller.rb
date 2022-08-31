# frozen_string_literal: true

module Api
  module V1
    module Admin
      # allows challenges api calls to challenge resources
      class FrontendChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        include ApplicationHelper
        before_action :problem_setter_auth
        before_action :admin_auth, only: %i[index]
        before_action :add_files, only: %i[update]
        before_action :remove_files, only: %i[destroy]
        def context
          {
            user: @current_user
          }
        end

        def self_created_challenges
          render_success({ id: @current_user.id, type: 'frontend_challenges', challenges: @current_user.frontend_challenges })
        end

        def add_files
          challenge = FrontendChallenge.find_by(id: params['id'])
          return render_not_found('challenge') if challenge.nil?

          bucket = 'frontend-testcases'
          files = params.dig(:data, :attributes, 'files')
          io_boilerplate(files, challenge.id.to_s, bucket)
          params['data']['attributes'].delete('files')
        end

        def remove_files
          challenge = FrontendChallenge.find_by(id: params['id'])
          return render_not_found('challenge') if challenge.nil?

          bucket = 'frontend-testcases'
          files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}#{bucket}", prefix: "#{challenge.id}/")
          io_boilerplate(files, '', bucket, 'remove')
        end

        def files_io
          challenge = FrontendChallenge.find_by(id: params.dig(:data, :attributes, 'id'))
          return render_not_found('challenge') if challenge.nil?

          bucket = 'frontend-testcases'
          files = params.dig(:data, :attributes, 'files')
          action = params.dig(:data, :attributes, 'action')
          io_boilerplate(files, challenge.id.to_s, bucket, action)
          render_success({ message: 'Updated Files' })
        end
      end
    end
  end
end
