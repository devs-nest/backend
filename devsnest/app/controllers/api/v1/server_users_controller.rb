# frozen_string_literal: true

module Api
  module V1
    # ServerUser Controller
    class ServerUsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[create]

      def create
        user = User.find_by(discord_id: params['data']['attributes']['user_id'])
        server = Server.find_by(guild_id: params['data']['attributes']['server_id'])

        return render_error({ message: 'Invalid Data' }) if user.nil? || server.nil?

        server_user = ServerUser.where(user_id: user.id, server_id: server.id).first_or_create(user_id: user.id, server_id: server.id)
        server_user.active = params['data']['attributes']['active']
        server_user.save
        render_success({ message: 'Data updated' })
      end
    end
  end
end
