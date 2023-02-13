# frozen_string_literal: true

module Api
  module V1
    module Admin
      # api for backend challenge
      class BackendChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        include ApplicationHelper
        before_action :problem_setter_auth
        before_action :admin_auth, only: %i[index]
        before_action :add_files, only: %i[update]
        before_action :remove_files, only: %i[destroy]

        def context
          {
            user: @current_user,
            action: params[:action]
          }
        end

        def self_created_challenges
          render_success({ id: @current_user.id, type: 'backend_challenges', challenges: @current_user.backend_challenges })
        end

        def add_files
          challenge = BackendChallenge.find_by(id: params['id'])
          return render_not_found('challenge') if challenge.nil?

          if challenge.challenge_type == 'stackblitz'
            bucket = 'backend-testcases'
            files = params.dig(:data, :attributes, 'files')
            return if files.nil?

            io_boilerplate(files, challenge.id.to_s, bucket)
            params['data']['attributes'].delete('files')
          end
        end

        def remove_files
          challenge = BackendChallenge.find_by(id: params['id'])
          return render_not_found('challenge') if challenge.nil?

          if challenge.challenge_type == 'stackblitz'
            bucket = 'backend-testcases'
            files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}#{bucket}", prefix: "#{challenge.id}/")
            io_boilerplate(files[:contents], '', bucket, 'remove')
          end
        end

        def files_io
          challenge = BackendChallenge.find_by(id: params.dig(:data, :attributes, :id))
          return render_not_found('challenge') if challenge.nil?

          bucket = 'backend-testcases'
          key = "#{challenge.id}/#{params.dig(:data, :attributes, :filename)}"
          remove_test_cases(bucket, key)

          render_success({ message: 'Updated files' })
        end
      end
    end
  end
end
