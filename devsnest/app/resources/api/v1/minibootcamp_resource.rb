# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Resource
    class MinibootcampResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :content_type, :markdown, :video_link, :current_lesson_number, :image_url
      attributes :module_tasks, :current_url, :next_url, :previous_url, :total_lessons
      filter :parent_id
      filter :unique_id
      filter :content_type

      def module_tasks
        @model.frontend_question&.as_json
      end

      def current_url
        "/api/v1/minibootcamp?filter[parent_id]=#{@context[:parent_id]}&filter[unique_id]=#{@model&.unique_id}"
      end

      def next_url
        next_lesson = Minibootcamp.find_by(parent_id: parent_id, current_lesson_number: @model.current_lesson_number+1)
        "/api/v1/minibootcamp?filter[parent_id]=#{@context[:parent_id]}&filter[unique_id]=#{next_lesson&.unique_id}" if next_lesson.present?
      end

      def previous_url
        prev_lesson = Minibootcamp.find_by(parent_id: parent_id, current_lesson_number: @model.current_lesson_number-1)
        "/api/v1/minibootcamp?filter[parent_id]=#{@context[:parent_id]}&filter[unique_id]=#{prev_lesson&.unique_id}" if prev_lesson.present?
      end

      def total_lessons
        minimum = Minibootcamp.where(parent_id: parent_id).count
      end
    end
  end
end
