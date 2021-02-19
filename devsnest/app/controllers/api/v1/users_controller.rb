# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :discord_authorize, except: [:update]

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
      
      def myuser
        if current_user
          byebug
          render json: current_user
        end
      end
      #  def update
      # #   user = User.find_by(email: email)
      #     #user = User.update_discord_id(user.uid)
      #    new_discord_id = params['data']['attributes']['discord_id']
      #     = Submission.create_submission(user.id, content.id, choice)

      # #   email = params['data']['attributes']['email']
      #  end

    end
  end
end
