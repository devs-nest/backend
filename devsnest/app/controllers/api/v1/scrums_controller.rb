# frozen_string_literal: true

module Api
  module V1
    # Scrum Controller
    class ScrumsController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index update create]
      before_action :authorize_get, only: %i[index]
      before_action :authorize_update, only: %i[update]
      before_action :authorize_create, only: %i[create]
      before_action :bot_auth, only: %i[weekly_leaderboard]

      def context
        {
          user: @current_user,
          group_id_get: params[:group_id],
          group_id_create: (params.dig 'data', 'attributes', 'group_id'),
          scrum_id: params[:id],
          date: (params[:date] || Date.current.to_s)
        }
      end

      def authorize_get
        group = Group.find_by(id: params[:group_id])
        return render_error('message': 'Group Not Found') unless group.present?
        return render_forbidden unless group.check_auth(@current_user)
      end

      def authorize_update
        scrum = Scrum.find_by(id: params[:data][:id])
        group = Group.find_by(id: scrum.group_id)
        return true if (@current_user.id == scrum.user_id || group.admin_rights_auth(@current_user)) && scrum.creation_date == Date.current

        render_error('message': 'You Cannot Update this Scrum.')
      end

      def authorize_create
        user_id = (params.dig 'data', 'attributes', 'user_id')
        group = Group.find_by(id: (params.dig 'data', 'attributes', 'group_id'))

        if (@current_user.id == user_id && group.group_members.where(user_id: user_id).present?) || group.admin_rights_auth(@current_user)
          scrum = Scrum.find_by(user_id: user_id, group_id: group.id, creation_date: Date.current)
          if scrum.present?
            scrum.handle_manual_update(params, group, @current_user) ? render_success(scrum: scrum.as_json) : render_error('message': 'Something Went Wrong')
          else
            true
          end
        else
          render_error('message': 'Permission Denied')
        end
      end

      def weekly_leaderboard
        result = weekly_leaderboard_data
        render_success(result: result.as_json)
      end
    end
  end
end
