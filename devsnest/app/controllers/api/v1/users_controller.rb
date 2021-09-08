# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[leaderboard report]
      before_action :bot_auth, only: %i[left_discord create index get_token update_discord_username]
      before_action :user_auth, only: %i[logout me update connect_discord onboard markdown_encode]
      before_action :update_college, only: %i[update onboard]
      before_action :update_username, only: %i[update]

      def context
        { user: @current_user }
      end

      def me
        @current_user.update(login_count: @current_user.login_count + 1) if @current_user.login_count < 3
        redirect_to api_v1_user_url(@current_user)
      end

      def get_by_username
        user = User.find_by(username: params[:id])
        return render_not_found unless user.present?

        redirect_to api_v1_user_url(user)
      end

      def get_token
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        return render_success({ id: user.id, type: 'bot_token', bot_token: user.bot_token }) if user.present?

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
        render_success({ id: user.id, type: 'report' }.merge(res))
      end

      def leaderboard
        @leaderboard.page_size = params[:size].to_i || 10
        page = params[:page].to_i
        @leaderboard.rank_member(@current_user.username, @current_user.score || 0) if @current_user.present?

        scoreboard = @leaderboard.leaders(page)
        pages_count = @leaderboard.total_pages

        if @current_user
          rank = @leaderboard.rank_for(@current_user.username)
          user = @leaderboard.member_at(rank)
          return render_success({ id: page, type: 'leaderboard', user: user, scoreboard: scoreboard, count: pages_count })
        end

        render_success({ id: page, type: 'leaderboard', scoreboard: scoreboard, count: pages_count })
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
        render_success(id: @current_user.id, type: 'logout', notice: 'You logged out successfully')
      end

      def connect_discord
        return render_error({ message: 'Please Connect with Discord or enter bot-token' }) unless params['code'].present? || params['data']['attributes']['bot_token'].present?

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
        Event.generate(Event::VERIFIED, @current_user)
        Event.generate(Event::WELCOME, @current_user)
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

      def update_username
        return render_unauthorized unless @current_user.id.to_s == params['data']['id']
        return true if params['data']['attributes']['username'].nil? || context[:user].username == params['data']['attributes']['username']

        return render_error({ message: 'Username pattern mismatched' })  if check_username(params['data']['attributes']['username'])

        return render_error({ message: 'User already exists' }) if User.find_by(username: params['data']['attributes']['username']).present?

        if context[:user].update_count >= 4
          render_error({ message: 'Update count Exceeded for username' })
        else
          @leaderboard.remove_member(context[:user].username)
          params['data']['attributes']['update_count'] = context[:user].update_count + 1
        end
      end

      def onboard
        updatable_params = params.require(:data).permit(attributes: %i[
                                                          discord_username discord_id name work_exp known_from grad_year
                                                          dsa_skill webd_skill is_discord_form_filled college_id
                                                        ])
        return render_error({ message: 'Discord form already filled' }) if @current_user.is_discord_form_filled

        return render_error({ message: "Discord isn't connected" }) unless @current_user.discord_active

        return render_error({ message: 'User already in a group' }) if GroupMember.find_by(user_id: @current_user.id)

        @current_user.update!(updatable_params[:attributes])
        render_success({ message: 'Form filled' })
      end

      def update_discord_username
        user = User.find_by(discord_id: params['data']['attributes']['discord_id'])

        return render_error({ message: 'User does not exist' }) if user.nil?

        user.update(discord_username: params['data']['attributes']['discord_username'])
        render_success(user.as_json.merge({ "type": 'users' }))
      end
    end
  end
end
