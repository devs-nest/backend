# frozen_string_literal: true

module Api
  module V1
    # frontend submission controller
    class FrontendQuestionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[show]

      def context
        {
          user: @current_user,
          parent: params[:parent_id]
        }
      end
    end
  end
end
