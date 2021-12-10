# frozen_string_literal: true

module Api
  module V1
    class MinibootcampResource < JSONAPI::Resource
      attributes :unique_id, :parent_id, :content_type, :markdown
      filter :parent_id
      filter :unique_id
      filter :content_type
    end
  end
end