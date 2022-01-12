# frozen_string_literal: true

module Api
  module V1
    module Admin
      # resource for frontend questions (minibootcamp)
      class FrontendQuestionResource < JSONAPI::Resource
        attributes :name, :question_markdown, :template, :active_path, :open_paths, :protected_paths, :hidden_files, :show_explorer
        attributes :template_files

        def template_files
          @model.template_files
        end
      end
    end
  end
end
