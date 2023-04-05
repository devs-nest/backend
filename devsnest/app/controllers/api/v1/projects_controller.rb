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
        return render_not_found if user.blank?

        projects = []

        Project.find_each do |project|
          challenge = project.challenge
          case project.challenge_type
          when 'Article'
            submission = ArticleSubmission.find_by(user_id: user.id, article_id: project.challenge_id)
            projects << { title: challenge.title, slug: challenge.slug, banner: project.banner } if submission.present?
            next
          when 'BackendChallenge'
            submission = BackendChallengeScore.find_by(user_id: user.id,
                                                       backend_challenge_id: project.challenge_id).where('passed_test_cases = total_test_cases')
          when 'FrontendChallenge'
            submission = FrontendChallengeScore.find_by(user_id: user.id,
                                                        frontend_challenge_id: project.challenge_id).where('passed_test_cases = total_test_cases')
          end

          if submission.present?
            projects << {
              banner: project.banner,
              name: challenge.name,
              difficulty: challenge.difficulty,
              slug: challenge.slug,
              score: challenge.score
            }
          end
        end

        render_success({ data: projects, type: 'projects' })
      end
    end
  end
end
