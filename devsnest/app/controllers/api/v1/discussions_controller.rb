# frozen_string_literal: true

module Api
  module V1
    # shows a list of content items for the current user
    class DiscussionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def context
        { user: @current_user }
      end
    end
  end
end
