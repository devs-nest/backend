# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Devsnest Projects
      class ProjectsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
        before_action :check_if_project_exists, only: %i[create]
        before_action :check_challenge_type, only: %i[create]

        def context
          {
            user: @current_user
          }
        end

        private

        def check_challenge_type
          challenge_type = params.dig(:data, :attributes, :challenge_type)
          return render_not_found('Challenge Type Not Found') if challenge_type != 'BackendChallenge' && challenge_type != 'FrontendChallenge' && challenge_type != 'Article'
        end

        def check_if_project_exists
          project = Project.find_by(challenge_type: params.dig(:data, :attributes, :challenge_type), challenge_id: params.dig(:data, :attributes, :challenge_id))
          return render_error('Project already exists') if project.present?
        end
      end
    end
  end
end
