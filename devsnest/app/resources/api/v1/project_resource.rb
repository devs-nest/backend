# frozen_string_literal: true

module Api
  module V1
    class ProjectResource < JSONAPI::Resource
      attributes :banner, :challenge_details, :challenge_id, :challenge_type, :submission_status, :intro

      def challenge_details
        return { title: @model.challenge.title, slug: @model.challenge.slug } if challenge_type == 'Article'

        {
          name: @model.challenge.name,
          difficulty: @model.challenge.difficulty,
          slug: @model.challenge.slug,
          score: @model.challenge.score
        }
      end

      def submission_status
        user = context[:user]
        return 'signin to check submissions' if user.nil?

        case @model.challenge_type
        when 'Article'
          submission = ArticleSubmission.find_by(user_id: user.id, article_id: @model.challenge_id)
          return submission.present? ? 'solved' : 'unsolved'
        when 'FrontendChallenge'
          submission = user.frontend_challenge_scores.find_by(frontend_challenge_id: @model.challenge_id)
        when 'BackendChallenge'
          submission = user.backend_challenge_scores.find_by(backend_challenge_id: @model.challenge_id)
        end

        return 'unsolved' if submission.blank?

        submission.passed_test_cases == submission.total_test_cases ? 'solved' : 'attempted'
      end
    end
  end
end
