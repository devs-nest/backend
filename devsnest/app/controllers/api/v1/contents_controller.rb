# frozen_string_literal: true

module Api
  module V1
    # shows a list of content items for the current user
    class ContentsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[index show]

      def context
        { user: @current_user }
      end
    end
  end
end
