# frozen_string_literal: true

module Api
  module V1
    module Admin
      # api for backend challenge
      class BackendChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :problem_setter_auth
        before_action :admin_auth, only: %i[index]

        def context
          {
            user: @current_user,
            action: params[:action]
          }
        end

        def self_created_challenges
          render_success({ id: @current_user.id, type: 'backend_challenges', challenges: @current_user.backend_challenges })
        end

        def active_questions
          backend_challenges = BackendChallenge.where(is_active: true).select('id', 'name', 'slug')
          render_success({ type: 'backend_challenges', challenges: backend_challenges })
        end
      end
    end
  end
end
