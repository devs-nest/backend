module Api
  module V1
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_get, only: %i[index]
      before_action :authorize_update, only: %i[update delete]
      before_action :check_scrum, only: %i[create]

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
        return true if @current_user.id == scrum.user_id || Scrum.check_scrum_auth(@current_user.id,group)
        render_error('message':'You Cannot Update this Scrum.')
      end

      def check_scrum
        user_id = params[:data][:attributes][:user_id]
        render_error('message':'Scrum already exists') if Scrum.find_by(user_id: user_id, created_at: Date.current.beginning_of_day..Date.current.end_of_day).present?
      end
    end
  end
end
