# frozen_string_literal: true

module Api
  module V1
    class ArticleResource < JSONAPI::Resource
      attributes :title, :content, :author, :banner, :category, :resource_type, :slug, :created_at, :updated_at
    end
  end
end
