# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Submission Resource
    class MinibootcampSubmissionResource < JSONAPI::Resource
      attributes :user_id, :frontend_question_id, :is_solved, :submission_link, :submission_status

      def self.records(options = {})
        context_user = options[:context][:current_user]
        context_user.present? ? super(options).where(user_id: options[:context][:current_user]&.id) : super(options)
      end
    end
  end
end
