# frozen_string_literal: true

module Api
  module V1
    # Devsnest Projects
    class ProjectsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      # frontend project public code

      def index
        be_projects = BackendChallenge.where(is_project: true, is_active: true).select(:id, :name, :question_body, :banner, :difficulty, :score, :slug).all
        fe_projects = FrontendChallenge.where(is_project: true, is_active: true).select(:id, :name, :difficulty, :slug, :score, :banner, :question_body).all
        web3 = Article.where(resource_type: 'article').select(:id, :author, :banner, :category, :content, :slug, :title).all

        data = {
          type: 'projects',
          be_projects: be_projects,
          fe_projects: fe_projects,
          web3: web3
        }
        render_success(data)
      end

      def completed
        user = User.find_by_username(params.dig(:data, :attributes, :username))
        return render_not_found if user.nil?

        completed_be_challenges = []
        completed_fe_challenges = []
        completed_web3 = []

        BackendChallenge.where(is_project: true, is_active: true).select(:id, :name, :banner, :slug).find_each do |be_challenge|
          submission = user.backend_challenge_scores.find_by(backend_challenge_id: be_challenge.id)
          completed_be_challenges << be_challenge if submission.present? && submission.passed_test_cases == submission.total_test_cases
        end

        FrontendChallenge.where(is_project: true, is_active: true).select(:id, :name, :banner, :slug).find_each do |fe_challenge|
          submission = user.frontend_challenge_scores.find_by(frontend_challenge_id: fe_challenge.id)
          completed_fe_challenges << fe_challenge if submission.present? && submission.passed_test_cases == submission.total_test_cases
        end

        Article.select(:id, :title, :banner, :slug).find_each do |article|
          submission = ArticleSubmission.find_by(user_id: user.id, article_id: article.id)
          completed_web3 << article if submission.present?
        end

        data = {
          type: 'projects',
          be_projects: completed_be_challenges,
          fe_projects: completed_fe_challenges,
          web3_projects: completed_web3
        }

        render_success(data)
      end
    end
  end
end
