# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Users Controller for Admin
      class UsersController < ApplicationController
        include JSONAPI::ActsAsResourceController
        include UtilConcern
        # before_action :admin_auth

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
          user = User.find_by(id: params.dig(:data, :attributes, 'id'))

          return render_error(message: 'No Data Found') unless user.present?
          return render_error(message: 'Can\'t decouple the user') unless user.discord_active && user.web_active

          user.un_merge_discord_user
          render_success({ message: 'User is decoupled!' })
        end
      end
    end
  end
end
