module Api
  module V1
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_get, only: %i[index]
      before_action :authorize_update, only: %i[update delete]
      

      def context
        {
          user:  @current_user,
          scrum:  Scrum.find_by(id: params[:id]),
          group_id: params[:group_id]
        }
      end

      def authorize_get
        group = Group.find_by(id: params[:group_id])
        group_id = params[:group_id].to_i
        user_group_id = GroupMember.find_by(user_id: @current_user.id).group_id
        return render_forbidden unless group_id == user_group_id || @current_user.id == group.batch_leader_id || @current_user.user_type == 'admin'
      end

      def authorize_update
        scrum = Scrum.find_by(id: params[:id])
        group = Group.find_by(id: params[:group_id])
        return true if @current_user.id == scrum.user_id || @current_user.id == group.owner_id|| @current_user.id == group.co_owner_id || @current_user.id == group.batch_leader_id ||@current_user.user_type == 'admin'
        render_error('message':'You Cannot Update this Scrum.')
      end

      def create
        user_id = params[:data][:attributes][:user_id]
        group_id = params[:data][:attributes][:group_id]
        group = Group.find_by(id: group_id)

        attendance = params[:data][:attributes][:attendance]
        saw_last_lecture = params[:data][:attributes][:saw_last_lecture]
        till_which_tha_you_are_done = params[:data][:attributes][:till_which_tha_you_are_done]
        what_will_you_cover_today = params[:data][:attributes][:what_will_you_cover_today]
        reason_for_backlog_if_any = params[:data][:attributes][:reason_for_backlog_if_any]

        return render_error('message':'Scrum already exists') if Scrum.find_by(user_id: user_id, created_at: Date.current.beginning_of_day..Date.current.end_of_day).present?
        if user_id == group.owner_id || user_id == group.co_owner_id || user_id == group.batch_leader_id || User.find_by(id: user_id).user_type == 'admin' 
          scrum = Scrum.create(user_id: user_id, group_id: group_id, attendance: attendance, saw_last_lecture: saw_last_lecture, till_which_tha_you_are_done: till_which_tha_you_are_done, what_will_you_cover_today: what_will_you_cover_today, reason_for_backlog_if_any: reason_for_backlog_if_any)
        else
          scrum = Scrum.create(user_id: user_id, group_id: group_id, saw_last_lecture: saw_last_lecture, till_which_tha_you_are_done: till_which_tha_you_are_done, what_will_you_cover_today: what_will_you_cover_today, reason_for_backlog_if_any: reason_for_backlog_if_any)
        end 
        render_success(scrum.as_json.merge("type": 'scrum'))
      end
    end
  end
end
