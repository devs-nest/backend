# frozen_string_literal: true

module Api
  module V1
    # Devsnest Projects
    class ProjectsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      # frontend project public code

      def index
        projects = []

        BackendChallenge.where(is_project: true, is_active: true).select(:id, :name, :question_body, :banner, :difficulty, :score, :slug).all.map do |h|
          projects << { id: h.id, name: h.name, question_body: h.question_body, banner: h.banner, difficulty: h.difficulty, score: h.score, slug: h.slug, type: 'be_projects' }
        end

        FrontendChallenge.where(is_project: true, is_active: true).select(:id, :name, :difficulty, :slug, :score, :banner, :question_body).all.map do |h|
          projects << { id: h.id, name: h.name, difficulty: h.difficulty, slug: h.slug, score: h.score, banner: h.banner, question_body: h.question_body, type: 'fe_projects' }
        end

        Article.where(resource_type: 'article').select(:id, :author, :banner, :category, :content, :slug, :title).all.map do |h|
          projects << { id: h.id, author: h.author, banner: h.banner, category: h.category, content: h.content, slug: h.slug, title: h.title, type: 'web3_projects' }
        end

        data = {
          type: 'projects',
          projects: projects
        }

        render_success(data)
      end

      def completed
        user = User.find_by_username(params.dig(:data, :attributes, :username))
        return render_not_found if user.nil?

        projects = []

        BackendChallenge.where(is_project: true, is_active: true).select(:id, :name, :banner, :slug).find_each do |ch|
          submission = user.backend_challenge_scores.find_by(backend_challenge_id: ch.id)
          projects << { id: ch.id, name: ch.name, banner: ch.banner, slug: ch.slug, type: 'be_projects' } if submission.present? && submission.passed_test_cases == submission.total_test_cases
        end

        FrontendChallenge.where(is_project: true, is_active: true).select(:id, :name, :banner, :slug).find_each do |ch|
          submission = user.frontend_challenge_scores.find_by(frontend_challenge_id: ch.id)
          projects << { id: ch.id, name: ch.name, banner: ch.banner, slug: ch.slug, type: 'be_projects' } if submission.present? && submission.passed_test_cases == submission.total_test_cases
        end

        Article.select(:id, :title, :banner, :slug).find_each do |ch|
          submission = ArticleSubmission.find_by(user_id: user.id, article_id: ch.id)
          projects << { id: ch.id, title: ch.title, banner: ch.banner, slug: ch.slug } if submission.present?
        end

        data = {
          type: 'projects',
          projects: projects
        }

        render_success(data)
      end
    end
  end
end
