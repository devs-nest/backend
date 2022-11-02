module Api
  module V1
    module Admin
      class ArticleResource < JSONAPI::Resource
        attributes :title, :content, :author, :banner, :category, :created_at, :updated_at
      end
    end
  end
end