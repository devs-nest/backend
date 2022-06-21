# frozen_string_literal: true

module Api
  module V1
    # ServerUser Controller
    class ServerUsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[create]
      before_action :authorize_create, only: %i[create]
      before_action :authorize_update, only: %i[update]

      def authorize_create
        user = User.find_by(discord_id: params['data']['attributes']['user_id'])
        server = Server.find_by(guild_id: params['data']['attributes']['server_id'])

        return render_error({ message: 'Invalid Data' }) if user.nil? || server.nil?

        server_user = ServerUser.find_by(user_id: user.id, server_id: server.id)

        return render_error({ message: 'Data already present' }) if server_user.present? && server_user.active?

        if server_user.present?
          server_user.update(active: true)
          return render_error({ message: 'Data updated' })
        end

        params['data']['attributes']['user_id'] = user.id
        params['data']['attributes']['server_id'] = server.id
      end

      def authorize_update
        user = User.find_by(discord_id: params['data']['attributes']['user_id'])
        server = Server.find_by(guild_id: params['data']['attributes']['server_id'])

        return render_error({ message: 'Invalid Data' }) if user.nil? || server.nil?

        server_user = ServerUser.find_by(user_id: user.id, server_id: server.id)

        return render_error({ message: 'Data already up-to-date' }) if server_user.present? && !server_user.active?

        params['data']['attributes']['user_id'] = user.id
        params['data']['attributes']['server_id'] = server.id
      end
    end
  end
end
