# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[leaderboard report show]
      before_action :bot_auth, only: %i[left_discord create index get_token]
      before_action :user_auth, only: %i[logout me update connect_discord]
      before_action :update_college, only: %i[update]

      def context
        { user: @current_user }
      end

      def me
        redirect_to api_v1_user_url(@current_user)
      end

      def get_token
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        return render json: { bot_token: user.bot_token } if user.present?

        render_error('User not found')
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
        render json: { notice: 'You logged out successfully' }
      end

      def connect_discord
        unless params['code'].present? || params['data']['attributes']['bot_token'].present?
          return render_error({ message: "Please Connect with Discord or enter bot-token" })
        end

        if params['code'].present?
          discord_id = User.fetch_discord_id(params['code'])
          return render_error({ message: 'Incorrect code from discord' }) if discord_id.nil?

          temp_user = User.find_by(discord_id: discord_id)
        elsif params['data']['attributes']['bot_token'].present?
          temp_user = User.find_by(bot_token: params['data']['attributes']['bot_token'])
          return render_error({ message: 'Could Not find User of Provided token' }) if temp_user.nil?
        end
        message = 'Discord user is already connected to another user'
        return render_error({ message: message }) if temp_user.web_active?

        @current_user.merge_discord_user(temp_user.discord_id, temp_user)
        render_success(@current_user.as_json.merge({ "type": 'users' }))
      end

      def login
        code = params['code']
        googleId = params['googleId']
        return render_error({ message: 'googleId parameter not specified' }) unless googleId

        user = User.fetch_google_user(code, googleId)
        if user.present?
          sign_in(user)
          set_current_user
          return render_success(user.as_json.merge({ "type": 'users' })) if @current_user.present?
        end
        render_error({ message: 'Error occured while authenticating' })
      end

      def update_college
        college_name = params['data']['attributes']['college_name']

        unless college_name.present?
          params['data']['attributes'].delete 'college_name'
          return true
        end

        College.create_college(college_name) unless College.exists?(name: college_name)
        params['data']['attributes']['college_id'] = College.find_by(name: college_name).id

        params['data']['attributes'].delete 'college_name'
      end
    end
  end
end
