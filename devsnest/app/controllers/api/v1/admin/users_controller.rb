# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Users Controller for Admin
      class UsersController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end

        def check_user_detais
          identifier = params['identifier']

          discord_user = User.find_by(discord_id: identifier)
          email_user = User.find_by(email: identifier)

          user = discord_user.present? ? discord_user : email_user
          return render_error({ message: 'User not found' }) if user.nil?

          render_success({ id: user.id, name: user.name, discord_id: user.discord_id, email: user.email, mergeable: user.discord_active || user.web_active })
        end

        def disconnect_user
          user = User.find_by(id: params['id'])

          return render_error(message: 'No Data Found') if user.nill?
          return render_error(message: 'Can\'t Decupple the user') unless user.discord_active && user.web_active

          user.un_merge_discord_user
          render_success({ message: 'User is decuppled!' })
        end
      end
    end
  end
end
