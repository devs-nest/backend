# frozen_string_literal: true

module Api
  module V1
    module Admin
      # allows challenges api calls to challenge resources
      class ChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        # before_action :problem_setter_auth

        def context
          {
            user: @current_user,
            challenge_id: params[:id]
          }
        end

        def add_testcase; end

        def testcases
          challenge = Challenge.where(id: params[:id]).first
          return render_not_found if challenge.nil?

          render_success({ id: params[:id], type: 'testcases', testcases: challenge.testcase })
        end
      end
    end
  end
end
