# frozen_string_literal: true

module Api
  module V1
    # Course Curriculum Controller
    class CourseCurriculumController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def context
        { user: @current_user }
      end
    end
  end
end
