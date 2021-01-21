# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def leaderboard
        scoreboard = User.order(score: :desc)
        render json: scoreboard
      end
    end
  end
end
