# frozen_string_literal: true

module Api
  module V1
    # Upvote Resourses
    class ServerUserResource < JSONAPI::Resource
      attributes :user_id, :server_id
    end
  end
end
