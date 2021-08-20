# frozen_string_literal: true

module Api
  module V1
    class MarkdownController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index]
    end
  end
end
