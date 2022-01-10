# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Frontend Question Controller
      class FrontendQuestionController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def create
          frontend_question_params = params[:data][:attributes].permit([:question_markdown, :template,
                                                                        :active_path, :show_explorer, { open_paths: [], protected_paths: [], hidden_files: [] }]).to_h
          frontend_question = FrontendQuestion.create!(frontend_question_params)
          template_files = params.dig(:data, :attributes, :template_files)
          if template_files.present?
            template_files.each do |filename, filecontent|
              FrontendQuestion.post_to_s3(frontend_question.id, filename, filecontent[:code])
            end
          end
          render_success({ id: frontend_question.id, type: 'frontend_question', frontend_question: frontend_question })
        end

        def update
          frontend_question = FrontendQuestion.find(params[:id])
          return render_error({ message: 'Frontend Question with this ID does not Exists' }) if frontend_question.nil?

          frontend_question_params = params[:data][:attributes].permit([:question_markdown, :template,
                                                                        :active_path, :show_explorer, { open_paths: [], protected_paths: [], hidden_files: [] }]).to_h
          frontend_question.update!(frontend_question_params)
          template_files = params.dig(:data, :attributes, :template_files)
          if template_files.present?
            template_files.each do |filename, filecontent|
              FrontendQuestion.post_to_s3(frontend_question.id, filename, filecontent[:code])
            end
          end
          render_success({ id: frontend_question.id, type: 'frontend_question', frontend_question: frontend_question })
        end
      end
    end
  end
end
