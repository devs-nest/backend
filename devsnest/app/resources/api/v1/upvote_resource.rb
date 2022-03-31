# frozen_string_literal: true

module Api
  module V1
    # Upvote Resourses
    class UpvoteResource < JSONAPI::Resource
      attributes :user_id, :content_id, :content_type
    end
  end
end
