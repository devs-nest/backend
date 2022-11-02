module Api
  module V1
    class ArticleController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end