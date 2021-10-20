# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class InternalFeedbackResource < JSONAPI::Resource
        attributes :id, :user_id, :user_name, :is_resolved, :feedback_type, :problems_faced, :issue_scale, :issue_details, :solution, :group_activity_rating, :TL_rating, :VTL_rating,
                   :group_morale, :obstacles_faced, :BL_availability, :BL_rating, :comments_on_BL, :created_at, :updated_at
        paginator :paged

        filter :span, apply: lambda { |records, value, _options|
          records.where('created_at >= ?', Date.parse(value[0]))
        }

        def self.records(options = {})
          super(options).where(feedback_type: options[:context][:feedback_type])
        end

        def fetchable_fields
          feedback_type = context[:feedback_type]
          case feedback_type
          when 'issue'
            super - %i[group_activity_rating TL_rating VTL_rating group_morale obstacles_faced BL_availability BL_rating comments_on_BL]
          when 'group_feedback'
            super - %i[problems_faced issue_scale issue_details solution BL_availability BL_rating comments_on_BL]
          when 'batch_leader_feedback'
            super - %i[problems_faced issue_scale issue_details solution group_activity_rating TL_rating VTL_rating group_morale obstacles_faced]
          end
        end
      end
    end
  end
end
