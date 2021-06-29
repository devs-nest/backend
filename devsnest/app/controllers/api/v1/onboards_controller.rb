# frozen_string_literal: true

module Api
  module V1
    # Used to vallidate onboarding forms
    class OnboardsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[create]
      before_action :register_user, only: %i[create]
      before_action :check_discord, only: %i[create]
      before_action :check_group, only: %i[create]
      after_action :update_user_profile, only: %i[create]

      def context
        { user: @current_user }
      end

      def register_user
        render_error('Form already filled') if Onboard.find_by(user_id: @current_user.id).present?

        params[:data][:attributes][:user_id] = @current_user.id
      end

      def check_discord
        render_error("Discord isn't connected") unless @current_user.discord_active
      end

      def check_group
        render_error('User already in a group') if GroupMember.find_by(user_id: @current_user.id)
      end

      def update_user_profile
        college = College.find_by(name: params[:data][:attributes][:college])
        college = College.create(name: params[:data][:attributes][:college]) if college.nil?
        @current_user.update(college_id: college.id)
      end
    end
  end
end
