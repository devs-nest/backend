# frozen_string_literal: true

module Api
  module V1
    class CollegeResource < JSONAPI::Resource
      attributes :name, :is_verified
    end
  end
end
