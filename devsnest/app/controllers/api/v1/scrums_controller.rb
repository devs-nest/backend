module Api
    module V1
      class ScrumsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :user_auth
        before_action :authorize_update, only: %i[update delete]
        before_action :authorize_get, only: [:show]
  
        def context
          {
            user:  @current_user,
            scrum:  Scrum.find_by(id: params[:id])
          }
        end
  
        def authorize_update
          scrum = Scrum.find_by(id: params[:id])
          scrum_group_owner_id = Group.find_by(id: scrum.group_id).owner_id
          return true if @current_user.id == scrum.user_id || @current_user.id == scrum_group_owner_id || @current_user.user_type == 'admin'
          render_forbidden
        end
  
        def authorize_get
          group_id = GroupMember.find_by(user_id: @current_user.id).group_id
          return render_forbidden unless group_id == Scrum.find_by(id: params[:id]).group_id || @current_user.user_type == 'admin'
        end
  
        def create
          batchmate_user_id = params['data']['attributes']['user_id']
  
          attendance = params['data']['attributes']['attendence']
          data = params['data']['attributes']['data']
          saw_last_lecture = params['data']['attributes']['saw_last_lecture']
          till_which_tha_you_are_done = params['data']['attributes']['till_which_tha_you_are_done']
          what_will_you_cover_today = params['data']['attributes']['what_will_you_cover_today']
          reason_for_backlog_if_any = params['data']['attributes']['reason_for_backlog_if_any']
  
  
          if batchmate_user_id == nil
            return render_forbidden if Scrum.find_by(user_id: @current_user.id, created_at: Date.current.beginning_of_day + 5.hour + 30.minute..Date.current.end_of_day + 5.hour + 30.minute).present?
          else
            return render_forbidden if Scrum.find_by(user_id: batchmate_user_id, created_at: Date.current.beginning_of_day + 5.hour + 30.minute..Date.current.end_of_day + 5.hour + 30.minute).present?
          end
          scrum = Scrum.create_scrum(context,batchmate_user_id, attendance, saw_last_lecture, till_which_tha_you_are_done, what_will_you_cover_today,reason_for_backlog)
          if scrum != nil
            render_success(scrum.as_json.merge("type": 'scrum'))
          else
            render_forbidden
          end
        end
      end
    end
  end