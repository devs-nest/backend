# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ArticleController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def web3_questions
          web3_challenges = Article.where(resource_type: 1).select('id', 'title', 'slug').map do |article|
            { id: article.id, name: article.title, slug: article.slug }
          end

          render_success({ type: 'article', challenges: web3_challenges })
        end
      end
    end
  end
end
