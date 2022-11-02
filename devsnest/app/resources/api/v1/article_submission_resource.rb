module Api
  module V1
    class ArticleSubmissionResource < JSONAPI::Resource
      attributes :user_id, :article_id, :submission_link, :created_at, :updated_at
    end
  end
end