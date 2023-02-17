# frozen_string_literal: true

module Api
  module V1
    # Devsnest Projects
    class ProjectsController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def context
        {
          user: @current_user
        }
      end

      def completed
        user = User.find_by_username(params[:username])
        return render_not_found('User') if user.nil?

        projects = []

        Project.find_each do |project|
          case project.challenge_type
          when 'Article'
            submission = ArticleSubmission.find_by(user_id: user.id, article_id: project.challenge_id)
            projects << { title: project.challenge.title, slug: project.challenge.slug, banner: project.banner } if submission.present?
          when 'BackendChallenge'
            submission = user.backend_challenge_scores.find_by(backend_challenge_id: project.challenge_id)
          when 'FrontendChallenge'
            submission = user.frontend_challenge_scores.find_by(frontend_challenge_id: project.challenge_id)
          end

          if project.challenge_type != 'Article'
            data = {
              banner: project.banner,
              name: project.challenge.name,
              difficulty: project.challenge.difficulty,
              slug: project.challenge.slug,
              score: project.challenge.score
            }
            projects << data if submission.present? && submission.passed_test_cases == submission.total_test_cases
          end
        end

        render_success({ data: projects, type: 'projects' })
      end
    end
  end
end
