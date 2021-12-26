# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Resource
    class MinibootcampResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :name, :content_type, :markdown, :video_link, :image_url, :show_ide, :module_tasks
      # attributes :module_tasks
      filter :parent_id
      filter :unique_id
      filter :content_type

      def module_tasks
        @model.frontend_questions&.first&.attributes
      end
    end
  end
end
