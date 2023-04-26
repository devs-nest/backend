# frozen_string_literal: true

module Api
  module V1
    # Shows a list of Events
    class EduEventsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def context
        { user: @current_user }
      end
    end
  end
end
