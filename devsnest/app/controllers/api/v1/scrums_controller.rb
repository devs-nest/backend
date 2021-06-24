# frozen_string_literal: true

module Api
  module V1
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_group, only: %i[create index]
      before_action :authorize_update, only: %i[update]

      def context
        {
          user:  @current_user,
          group_id: params[:group_id]
        }
      end

      def authorize_group
        group = Group.find_by(id: params[:group_id])
        return render_forbidden unless group.check_auth(@current_user)
      end

      def authorize_update
        scrum = Scrum.find_by(id: params[:id])
        group = Group.find_by(id: params[:group_id])
        return true if @current_user.id == scrum.user_id || group.admin_rights_auth(@current_user)

        render_error('message': 'You Cannot Update this Scrum.')
      end
    end
  end
end
