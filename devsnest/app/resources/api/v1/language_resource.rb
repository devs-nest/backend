# frozen_string_literal: true

module Api
  module V1
    # Markdown Resourses
    class LanguageResource < JSONAPI::Resource
      attributes :name, :judge_zero_id, :language_description

      def self.records(options = {})
        super(options).where.not(name: "javascript")
      end
    end
  end
end
