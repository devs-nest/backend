# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ArticleController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end
