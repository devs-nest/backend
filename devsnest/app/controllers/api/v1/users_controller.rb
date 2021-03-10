# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[leaderboard report show]
      before_action :bot_auth, only: %i[left_discord create index]
      before_action :user_auth, only: [:logout, :me]

      def context
        { user: @current_user }
      end

      def me
        render_success(@current_user.as_json.merge({ "type": 'users' }))
      end

      def report
        if @current_user.present?
          user = @current_user
        elsif @bot.present?
          discord_id = params[:discord_id]
          user = User.find_by(discord_id: discord_id)
          return render_error('User not found') if user.nil?
        end
        days = params[:days].to_i || nil
        res = Submission.user_report(days, user.id)
        render json: res
      end

      def leaderboard
        page = params[:page].to_i
        size = params[:size] || 10
        size = size.to_i
        offset = [(page - 1) * size, 0].max
        scoreboard = User.order(score: :desc).limit(size).offset(offset)
        pages_count = (User.count % size).zero? ? User.count / size : User.count / size + 1
        render json: { scoreboard: scoreboard, count: pages_count }
      end

      def create
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        if user
          user.discord_active = true
          user.save
          return render_success(user.as_json.merge({ "type": 'users', status: 'status updated' }))
        end
        super
      end

      def left_discord
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        user.discord_active = false
        user.save
        render_success(user.as_json.merge({ "type": 'users', status: 'status updated' }))
      end

      def logout
        render json: { notice: 'You logged out successfuly' }
      end

      def login
        code = params['code']
        user = User.fetch_discord_user(code)
        if user.present?
          sign_in(user)
          set_current_user
          return render_success(user.as_json.merge({ "type": 'users'})) if @current_user.present?
        end
        return render_error({message: "Error occured while authenticating"})
      end
    end
  end
end
