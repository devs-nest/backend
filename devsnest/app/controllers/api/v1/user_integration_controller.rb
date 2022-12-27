module Api
  module V1
    class UserIntegrationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def context
        { user: @current_user }
      end
    end
  end
end
