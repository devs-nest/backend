# frozen_string_literal: true

module Api
  module V1
    class ContentResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :data_type, :link, :priority, :score, :difficulty, :question_type, :youtube_link, :reference_link
      attributes :status

      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :question_type
      filter :difficulty
      def self.default_sort
        [{ field: 'priority', direction: :asc }]
      end

      def status
        return "notdone" if context[:user].nil?

        user_id = context[:user].id
        submission = Submission.where(user_id: user_id, content_id: @model.id).first
        return submission.status if submission.present?
        return "notdone"
      end
    end
  end
end
