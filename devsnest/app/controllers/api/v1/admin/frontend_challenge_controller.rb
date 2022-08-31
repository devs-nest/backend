# frozen_string_literal: true

module Api
  module V1
    module Admin
      # allows challenges api calls to challenge resources
      class FrontendChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
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

          return if params.dig('data', 'attributes', 'files').nil?

          files = params.dig('data', 'attributes', 'files')
          files.each do |file|
            challenge.put_test_cases(file[1], "#{challenge.id}#{file[0]}")
            challenge.update!(testcases_path: "#{challenge.id}#{file[0]}") if file[0].include?('test')
          end
          params['data']['attributes'].delete('files')
        end

        def remove_files
          challenge = FrontendChallenge.find_by(id: params['id'])
          return render_not_found('challenge') if challenge.nil?

          files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", prefix: "#{challenge.id}/")
          files.contents.each do |file|
            challenge.remove_test_cases(file.key.to_s)
          end
        end
      end
    end
  end
end
