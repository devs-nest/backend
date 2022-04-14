# frozen_string_literal: true

module Api
  module V1
    class NotificationBotController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :bot_auth, only: %i[index show]
      before_action :admin_auth, only: %i[update]
      before_action :fetch_token, only:%i[show]
      
      def fetch_token
        bot_data= NotificationBot.find_by(id: params[:id])
        return render_error('Bot Not Found ') if bot_data.nil?
        
        render json: bot_data.bot_token
      end


    end
  end
end
