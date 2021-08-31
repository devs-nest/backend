# frozen_string_literal: true

module Api
  module V1
    # Controller For Weekly Todo
    class WeeklyTodoController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :authorize_index, only: %i[index streak]
      before_action :authorize_create, only: %i[create]
      before_action :authorize_update, only: %i[update]

      def context
        {
          user: @current_user,
          date: params[:date].present? ? params[:date] : Date.current.to_s,
          group_id: params[:group_id]
        }
      end

      def streak
        weekly_todo = WeeklyTodo.where(group_id: params[:id])
        streak = weekly_todo.order('creation_week').pluck('creation_week,sheet_filled')
        return render_success({ id: params[:id], type: 'weekly_todo_streak', streak: [] }) if streak.empty?

        start_date = streak[0][0]
        end_date = streak[-1][0]
        index = 0
        while start_date <= end_date
          streak.insert(index, [start_date, false]) if streak[index][0] != start_date
          index += 1
          start_date += 7
        end

        render_success({ id: weekly_todo.first.id, type: 'weekly_todo_streak', streak: streak })
      end

      def authorize_index
        curr_group = if params[:id].present?
                       Group.find(params[:id])

                     else
                       Group.find(params[:group_id])
                     end

        render_forbidden unless !curr_group.present? || curr_group.check_auth(@current_user)
      end

      def authorize_update
        sheet = WeeklyTodo.find_by(id: params[:data][:id])
        render_forbidden unless !sheet.present? || sheet.group.group_admin_auth(@current_user)
        render_error('message': 'You cannot Update this sheet') unless sheet.creation_week == Date.current.at_beginning_of_week
      end

      def authorize_create
        curr_group = Group.find(params[:data][:attributes][:group_id])
        render_error('message': 'You cannot Create this sheet') unless !curr_group.present? || curr_group.check_auth(@current_user)
      end
    end
  end
end
