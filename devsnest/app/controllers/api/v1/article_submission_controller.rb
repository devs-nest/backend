module Api
  module V1
    class ArticleSubmissionController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end