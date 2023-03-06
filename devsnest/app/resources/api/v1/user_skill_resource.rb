# frozen_string_literal: true

module Api
  module V1
    # Upvote Resourses
    class UserSkillResource < JSONAPI::Resource
      attributes :skill_id, :user_id, :level
    end
  end
end