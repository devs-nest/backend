# frozen_string_literal: true

module Api
  module V1
    # Upvote Resourses
    class UserIntegrationResource < JSONAPI::Resource
      attributes :leetcode_user_name, :user_id
    end
  end
end