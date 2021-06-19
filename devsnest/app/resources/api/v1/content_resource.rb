# frozen_string_literal: true

module Api
  module V1
    class ContentResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :data_type, :link, :priority, :score, :difficulty, :question_type, :reference_link, :questions_list, :video_questions
      attributes :status, :youtube_link

      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :question_type
      filter :difficulty
      def self.default_sort
        [{ field: 'priority', direction: :asc }]
      end

      def questions_list
        Content.where(id: video_questions.map(&:to_i)).as_json
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
