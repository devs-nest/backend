# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Devsnest Projects
      class ProjectsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
        before_action :check_challenge_type, only: %i[create]
        before_action :check_if_project_exists, only: %i[create]
        after_action :make_project_true, only: %i[create]
        before_action :make_project_false, only: %i[destroy]

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

        def make_project_true
          project = Project.find_by(challenge_type: params.dig(:data, :attributes, :challenge_type), challenge_id: params.dig(:data, :attributes, :challenge_id))
          project.challenge.update!(is_project: true) if project.challenge_type != 'Article'
        end

        def make_project_false
          project = Project.find_by_id(params[:id])
          return render_not_found('project') if project.nil?

          project.challenge.update!(is_project: false) if project.challenge_type != 'Article'
        end
      end
    end
  end
end
