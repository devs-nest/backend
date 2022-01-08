# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Minibootcamp Resource
      class MinibootcampResource < JSONAPI::Resource
        attributes :unique_id, :parent_id, :name, :content_type, :markdown, :video_link, :current_lesson_number, :image_url
        filter :parent_id
        filter :unique_id
        filter :content_type
      end
    end
  end
end
