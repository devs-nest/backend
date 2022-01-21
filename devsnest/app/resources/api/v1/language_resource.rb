# frozen_string_literal: true

module Api
  module V1
    # Markdown Resourses
    class LanguageResource < JSONAPI::Resource
      attributes :name, :judge_zero_id
    end
  end
end
