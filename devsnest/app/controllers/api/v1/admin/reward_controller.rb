# frozen_string_literal: true

module Api
  module V1
    module Admin
      # link controller for urls
      class RewardController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def create
          data = params.dig(:data, :attributes)
          reward_fields = data.slice(:title, :description).permit(:title, :description)

          return render_error(message: "Can only reward user once in a 24 hrs") if CoinLog.where(user_id: data[:user_id]).where("created_at > ?", Date.today - 1.day).present?

          CoinLog.create(coins: data[:coins] || 0, user_id: data[:user_id], pointable: Reward.create(reward_fields))

          render_success(message: 'Reward created')
        end
      end
    end
  end
end
