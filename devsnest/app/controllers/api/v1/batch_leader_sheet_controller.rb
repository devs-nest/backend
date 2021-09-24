# frozen_string_literal: true

module Api
  module V1
    # Batch Leader Sheet Controller
    class BatchLeaderSheetController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :authorize_sheet, only: %i[index update]
      before_action :authorize_create, only: %i[create]
      before_action :check_updatable_sheet, only: %i[update]

      def context
        {
          user: @current_user,
          date: params[:date].present? ? params[:date] : Date.current,
          group_id: params[:group_id]
        }
      end

      def authorize_sheet
        if params[:action] == 'index'
          group = Group.find_by(id: params[:group_id])
        else
          sheet = BatchLeaderSheet.find_by(id: params[:data][:id])
          group = Group.find_by(id: sheet.group_id)
        end
        return render_error(message: 'Group Not Found') unless group.present?

        return true if @current_user.id == group.batch_leader_id || @current_user.user_type == 'admin'

        render_forbidden
      end

      def authorize_create
        user = User.find_by(id: params[:data][:attributes][:user_id])
        group = Group.find_by(id: params[:data][:attributes][:group_id])
        return true if (user.id == group.batch_leader_id) && ((@current_user.id == user.id) || (@current_user.user_type == 'admin'))

        render_error('message': 'You cannot Create this sheet')
      end

      def check_updatable_sheet
        sheet = BatchLeaderSheet.find_by(id: params[:data][:id])
        return true if sheet.creation_week == Date.current.at_beginning_of_week

        render_error('message': 'You cannot Update this sheet')
      end
    end
  end
end
