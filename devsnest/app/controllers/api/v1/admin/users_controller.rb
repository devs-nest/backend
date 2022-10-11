# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Users Controller for Admin
      class UsersController < ApplicationController
        include JSONAPI::ActsAsResourceController
        include UtilConcern
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end

        def check_user_details
          identifier = params['identifier']

          discord_user = User.find_by(discord_id: identifier)
          email_user = User.find_by(email: identifier)

          user = discord_user.present? ? discord_user : email_user
          return render_error({ message: 'User not found' }) unless user.present?

          data = get_user_details(user)

          render_success(data)
        end

        def disconnect_user
          disconnect_discord_user(params.dig(:data, :attributes, 'id'))
        end
      end
    end
  end
end
