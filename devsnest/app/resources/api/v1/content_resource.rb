# frozen_string_literal: true

module Api
  module V1
    # Content Resource
    class ContentResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :data_type, :link, :priority, :score, :difficulty, :question_type, :reference_data
      attributes :status, :questions_list, :video_questions

      filter :parent_id
      filter :unique_id
      filter :data_type
      filter :question_type
      filter :difficulty
      def self.default_sort
        [{ field: 'priority', direction: :asc }]
      end

      def questions_list
        contents = Content.where(id: video_questions)
        return [] if video_questions.nil?

        questions = []
        contents.each do |c|
          sub = Submission.where(user_id: context[:user].id, content_id: c.id).first

          questions.push c.as_json.merge(status: sub.present? ? sub.status : 'notdone')
        end
        questions
      end

      def status
        return 'notdone' if context[:user].nil?

        user_id = context[:user].id
        submission = Submission.where(user_id: user_id, content_id: @model.id).first
        return submission.status if submission.present?

        return 'notdone'
      end
    end
  end
end
