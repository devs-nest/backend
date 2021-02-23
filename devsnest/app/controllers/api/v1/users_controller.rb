# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def report
        discord_id = params[:discord_id]
        user = User.find_by(discord_id: discord_id)
        return render_error('User not found') if user.nil?

        days = params[:days].to_i || nil
        res = Submission.user_report(days, user.id)
        render json: res
      end

      def leaderboard
        page = params[:page].to_i
        offset = (page - 1)* 10
        scoreboard = User.order(score: :desc).limit(10).offset(offset)
        pages_count = User.count%10 == 0? User.count/10 : User.count/10 + 1
        render json: { scoreboard: scoreboard, count: pages_count }
      end

      def update_status
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        active = params['data']['attributes']['active']
        user.active= active
        user.save
        render json: { status: "status updated"}
      end

    end
  end
end
