# frozen_string_literal: true

module Api
  module V1
    # Controller for Sql Challenge
    class SqlChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :check_params, only: :save_result

      def context
        {
          action: params[:action],
          user: @current_user
        }
      end

      def save_result
        return render_error('User ID does not match current logged in user') if @current_user.id != params[:user_id]

        user = User.find_by_id(params[:user_id])
        sql_challenge = SqlChallenge.find_by_slug(params[:sql_challenge_slug])

        return render_not_found if user.nil? || sql_challenge.nil?

        sql_submission = SqlSubmission.find_by(user_id: user.id, sql_challenge_id: sql_challenge.id)
        SqlSubmission.create!(user_id: user.id, sql_challenge_id: sql_challenge.id, score: params[:score], passed: params[:passed]) if sql_submission.nil?

        render_success({ message: 'Result Saved!' })
      end

      private

      def check_params
        return render_error('Invalid params') if params[:user_id].nil? || params[:sql_challenge_slug].nil? || params[:score].nil? || params[:passed].nil?
      end
    end
  end
end
