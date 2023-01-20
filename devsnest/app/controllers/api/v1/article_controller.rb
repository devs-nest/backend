# frozen_string_literal: true

module Api
  module V1
    # Article Controller
    class ArticleController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[create_submission]

      def index
        resource_type = params[:resource_type]
        resource = Article.all.where(resource_type: resource_type)
        return render_not_found('resource') if resource.blank?

        render_success(resource.as_json)
      end

      def fetch_by_slug
        article = Article.find_by(slug: params[:slug])
        return render_not_found('resource') if article.nil?

        user_submission = article.article_submissions&.find_by(user_id: @current_user&.id)

        render_success(article.as_json.merge(user_submission: user_submission&.slice(:submission_link)))
      end

      def create_submission
        article_id = params['data']['attributes']['article_id']
        article_submission = ArticleSubmission.find_by(user_id: @current_user.id, article_id: article_id)
        if article_submission.present?
          article_submission.update(submission_link: params['data']['attributes']['submission_link'])
        else
          article_submission = ArticleSubmission.new(article_id: article_id, user_id: @current_user.id, submission_link: params['data']['attributes']['submission_link'])
          article_submission.save!
        end
        render_success(article_submission.as_json)
      end
    end
  end
end
