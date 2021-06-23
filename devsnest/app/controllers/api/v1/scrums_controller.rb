module Api
  module V1
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_get, only: %i[index]
      before_action :authorize_update, only: %i[update]
      before_action :group_auth, :update_date, only: %i[create]

      def context
        {
          user:  @current_user,
          group_id: params[:group_id]
        }
      end

      def authorize_get
        group = Group.find_by(id: params[:group_id])
        return render_forbidden unless group.check_auth(@current_user)
      end

      def authorize_update
        scrum = Scrum.find_by(id: params[:id])
        group = Group.find_by(id: params[:group_id])
        return true if @current_user.id == scrum.user_id || group.check_scrum_edit_auth(@current_user)
        render_error('message':'You Cannot Update this Scrum.')
      end

      def group_auth
        user_id = params[:data][:attributes][:user_id]
        group = Group.where(id:params[:group_id]).first
        unless group.group_members.where(user_id: user_id).present?
          render_error('message': 'User is not a Part of Group')
        end
      end

      def update_date
        params['data']['attributes']['date'] = Date.current
      end
    end
  end
end
