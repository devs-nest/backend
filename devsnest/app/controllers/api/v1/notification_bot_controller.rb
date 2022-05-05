# frozen_string_literal: true

module Api
  module V1
    # controller for the notification bot
    class NotificationBotController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[index show]
      before_action :admin_auth, only: %i[update]
      before_action :fetch_token, only: %i[show]

      def fetch_token
        bot_data = NotificationBot.find_by(id: params[:id])
        return render_error('Bot Not Found ') if bot_data.nil?

        render json: bot_data.bot_token
      end

      def change_token
        bot_data = NotificationBot.find_by(id: params[:id])
        return render_error('Bot Not Found ') if bot_data.nil?

        new_bot = NotificationBot.where(is_used: false)&.first
        return render_error('No New Bot Found ') if new_bot.nil?

        bot_data.update(bot_token: new_bot.bot_token)
        new_bot.update(is_used: true)
      end
    end
  end
end
