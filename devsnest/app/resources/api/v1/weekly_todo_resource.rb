# frozen_string_literal: true

module Api
  module V1
    # Class for Weekly Todo
    class WeeklyTodoResource < JSONAPI::Resource
      attributes :group_id, :sheet_filled, :creation_week, :batch_leader_rating, :extra_activity, :group_activity_rating, :moral_status, :obstacles, :comments, :todo_list
      attributes :end_week

      def end_week
        creation_week + 6.days
      end

      def updatable_fields(context)
        super - %i[creation_week group_id]
      end

      def creatable_fields(context)
        super - %i[creation_week]
      end

      def self.records(options = {})
        if options[:context][:group_id].present?
          super(options).where(group_id: options[:context][:group_id], creation_week: Date.current.at_beginning_of_week)
        else
          super(options)
        end
      end
    end
  end
end
