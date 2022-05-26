# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Course Controller for Admin
      class CourseController < ApplicationController
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
