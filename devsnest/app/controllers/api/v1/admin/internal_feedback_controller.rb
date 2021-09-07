# frozen_string_literal: true

module Api
  module V1
    module Admin
      # InternalFeedback Controller for Admin
      class InternalFeedbackController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end
      end
    end
  end
end
