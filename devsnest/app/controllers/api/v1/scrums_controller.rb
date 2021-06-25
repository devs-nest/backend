# frozen_string_literal: true

module Api
  module V1
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_get, only: %i[index]
      before_action :authorize_update, only: %i[update]
      before_action :authorize_create, only: %i[create]

      def context
        {
          user:  @current_user,
          params: params
        }
      end

      def authorize_get
        group = Group.find_by(id: params[:group_id])
        return render_forbidden unless group.check_auth(@current_user)
      end

      def authorize_update
        scrum = Scrum.find_by(id: params[:data][:id])
        group = Group.find_by(id: scrum.group_id)
        return true if @current_user.id == scrum.user_id || group.admin_rights_auth(@current_user)

        render_error('message': 'You Cannot Update this Scrum.')
      end

      def authorize_create
        user_id = params[:data][:attributes][:user_id]
        group = Group.find_by(id: params[:data][:attributes][:group_id])
        return true if @current_user.id == user_id || group.admin_rights_auth(@current_user)

        render_error('message': 'Permission Denied')
      end
    end
  end
end
