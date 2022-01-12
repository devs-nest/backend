# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Resource
    class MinibootcampResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :content_type, :markdown, :video_link, :current_lesson_number, :image_url, :show_ide, :frontend_question_id
      attributes :current_url, :next_url, :previous_url, :total_lessons
      filter :parent_id
      filter :unique_id
      filter :content_type

      def current_url
        @model&.unique_id
      end

      def next_url
        next_lesson = Minibootcamp.find_by(parent_id: parent_id, current_lesson_number: @model.current_lesson_number + 1)
        next_lesson&.unique_id
      end

      def previous_url
        prev_lesson = Minibootcamp.find_by(parent_id: parent_id, current_lesson_number: @model.current_lesson_number - 1)
        prev_lesson&.unique_id
      end

      def total_lessons
        Minibootcamp.where(parent_id: parent_id).count
      end
    end
  end
end
