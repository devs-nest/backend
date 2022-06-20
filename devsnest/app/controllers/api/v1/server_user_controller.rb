# frozen_string_literal: true

module Api
  module V1
    # ServerUser Controller
    class ServerUserController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[create]
      before_action :authorize_create, only: %i[create]

      def authorize_create
        user = User.find_by(discord_id: params['data']['attributes']['user_id'])
        server = Server.find_by(guild_id: params['data']['attributes']['server_id'])

        return render_error({ message: 'Invalid' }) if user.nil? || server.nil?
        return render_error({ message: 'Data already present' }) if ServerUser.find_by(user_id: user.id, server_id: server.id).present?

        params['data']['attributes']['user_id'] = user.id
        params['data']['attributes']['server_id'] = server.id
      end
    end
  end
end
