# frozen_string_literal: true

module Api
  module V1
    class CoinLogsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :admin_auth, only: %i[redeem_for_session]

      def redeem_for_session
        data = params.dig(:data, :attributes)
        user = User.find_by(id: data[:user_id])

        return render_error("message": "User not found") if user.blank?
        coins = data[:coins].to_i
        return render_error("message": "Insufficient coins") if user.score < coins 
        coins *= -1 if coins.positive?
        
        CoinLog.create(pointable_type: "Session", coins: coins, user_id: user.id)
        user.update(coins: user.coins - coins)

        render_success({ id: user.id, type: 'session', message: "Points reedemed for session" })
      end
    end
  end
end
