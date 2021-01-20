# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController


      def leaderboard
   #    discord_id = params['data']['attributes']['discord_id']
   #    question_unique_id = params['data']['attributes']['question_unique_id']
   #    user = User.find_by(discord_id: discord_id)
   #    content = Content.find_by(unique_id: question_unique_id)

	  # return render_error('User or Content not found') if user.nil? || content.nil?

   #    choice = params['data']['attributes']['status']

   #    Submission.create_submission(user.id,content.id,choice)
      scoreboard = User.order(score: :asc)
      render json: scoreboard
      end
    end
  end
end
