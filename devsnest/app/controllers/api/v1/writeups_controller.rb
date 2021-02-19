# frozen_string_literal: true

module Api
  module V1
    class WriteupsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :params_change, only: :create
      before_action :discord_authorize

      def params_change
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        return render_error('User not found') if user.nil?

        # return head 404
        params['data']['attributes'].delete('discord_id')
        params['data']['attributes']['user_id'] = user.id
      end
    end
  end
end
