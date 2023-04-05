# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Devsnest Projects
      class ProjectsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
        before_action :create_validation, only: %i[create]

        def context
          {
            user: @current_user
          }
        end

        private

        def create_validation
          challenge_type = params.dig(:data, :attributes, :challenge_type)
          return render_not_found('Challenge Type Not Found') if %w[BackendChallenge FrontendChallenge Article].exclude?(challenge_type)

          project = Project.find_by(challenge_type: params.dig(:data, :attributes, :challenge_type), challenge_id: params.dig(:data, :attributes, :challenge_id))
          return render_error('Project already exists') if project.present?
        end
      end
    end
  end
end
