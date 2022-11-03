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
          user = User.find_by(id: params.dig(:data, :attributes, 'id'))

          return render_error(message: 'No Data Found') unless user.present?
          return render_error(message: 'Can\'t decouple the user') unless user.discord_active && user.web_active

          user.un_merge_discord_user
          render_success({ message: 'User is decoupled!' })
        end

        def support_mail
          filter = params.dig(:data, :attributes, 'filter')
          template_id = params.dig(:data, :attributes, 'template_id')
          parameters = params.dig(:data, :attributes, 'parameters') || {}
          users  = User.where(filter).where.not(id: Unsubscribe.all.pluck(:user_id))
          return render_error({ message: 'No Template ID Found' }) if template_id.blank?
          return render_error({ message: 'Not a valid filter' }) if users.blank?

          send_mails_from_admin(@current_user, users, template_id, parameters)
          render_success({ message: "Emails sent successfully to #{users.count} Users" })
        end
      end
    end
  end
end
