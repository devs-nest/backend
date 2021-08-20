# frozen_string_literal: true

module Api
  module V1
    # Markdown Resourses
    class MarkdownResource < JSONAPI::Resource
      attributes :template
      def template
        @model.template.dup.encode('ISO-8859-1').force_encoding('utf-8') unless @model.template.blank?
      end
    end
  end
end
