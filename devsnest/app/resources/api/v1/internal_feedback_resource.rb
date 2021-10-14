# frozen_string_literal: true

module Api
  module V1
    # internal resource feedback
    class InternalFeedbackResource < JSONAPI::Resource
      attributes :id, :user_id, :user_name, :is_resolved, :feedback_type, :problems_faced, :issue_scale, :issue_details, :solution, :group_activity_rating, :TL_rating, :VTL_rating,
                 :group_morale, :obstacles_faced, :BL_availability, :BL_rating, :comments_on_BL, :created_at, :updated_at

      def self.records(options = {})
        super(options).where(user: options[:context][:user])
      end
    end
  end
end
