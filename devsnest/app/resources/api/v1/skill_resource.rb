# frozen_string_literal: true

module Api
  module V1
    class SkillResource < JSONAPI::Resource
      caching
      attributes :name, :logo
    end
  end
end
