# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class InternalFeedbackResource < JSONAPI::Resource
        attributes :id, :user_id, :user_name, :is_resolved, :issue_type, :issue_described, :feedback, :issue_scale
      end
    end
  end
end
