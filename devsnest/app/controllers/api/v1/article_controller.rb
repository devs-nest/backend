module Api
  module V1
    class ArticleController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[create_submission]

      def fetch_by_slug
        article = Article.find_by(slug: params[:slug])
        user_submission = article&.article_submissions&.find_by(user_id: @current_user&.id)
        return render_not_found('article') if article.nil?

        render_success(article.as_json.merge(user_submission: user_submission&.slice(:submission_link)))
      end

      def create_submission
        article_id = params['data']['attributes']['article_id']
        if ArticleSubmission.find_by(user_id: @current_user.id, article_id: article_id).present?
          article_submission = ArticleSubmission.find_by(user_id: @current_user.id, article_id: article_id)
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
