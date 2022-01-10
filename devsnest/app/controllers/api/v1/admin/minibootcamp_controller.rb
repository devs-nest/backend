# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Minibootcamp Controller
      class MinibootcampController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def frontend_question
          minibootcamp = Minibootcamp.find(params[:id])
          minibootcamp_frontend_question = minibootcamp.try(:frontend_question)
          return render_not_found if (minibootcamp.nil? || minibootcamp_frontend_question.nil?)

          template_files = minibootcamp_frontend_question.template_files || {}
          render_success({ id: params[:id], type: 'frontend_question', frontend_question: minibootcamp_frontend_question.attributes.merge({ template_files: template_files }) })
        end

        def create_frontend_question
          minibootcamp_id = params[:id]
          return render_error({ message: 'Frontend Question for this already Exists' }) if Minibootcamp.find(minibootcamp_id).frontend_question.present?

          params[:data][:attributes][:minibootcamp_id] = minibootcamp_id
          frontend_question_params = params[:data][:attributes].permit([:minibootcamp_id, :question_markdown, :template,
                                                                        :active_path, :show_explorer, { open_paths: [], protected_paths: [], hidden_files: [] }]).to_h
          frontend_question = FrontendQuestion.create!(frontend_question_params)
          template_files = params.dig(:data, :attributes, :template_files)
          if template_files.present?
            template_files.each do |filename, filecontent|
              FrontendQuestion.post_to_s3(frontend_question.id, filename, filecontent[:code])
            end
          end
          render_success({ message: 'Frontend Question Created Successfully' })
        end

        def update_frontend_question
          minibootcamp = Minibootcamp.find(params[:id])
          minibootcamp_frontend_question = minibootcamp.frontend_question
          return render_error({ message: 'Frontend Question for this do not Exists' }) if minibootcamp_frontend_question.nil?

          frontend_question_params = params[:data][:attributes].permit([:minibootcamp_id, :question_markdown, :template,
                                                                        :active_path, :show_explorer, { open_paths: [], protected_paths: [], hidden_files: [] }]).to_h
          frontend_question = minibootcamp_frontend_question.update(frontend_question_params)
          template_files = params.dig(:data, :attributes, :template_files)
          if template_files.present?
            template_files.each do |filename, filecontent|
              FrontendQuestion.post_to_s3(frontend_question.id, filename, filecontent[:code])
            end
          end
          render_success({ message: 'Frontend Question Updated Successfully' })
        end

        def delete_frontend_question
          minibootcamp = Minibootcamp.find(params[:id])
          minibootcamp_frontend_question = minibootcamp.frontend_question
          return render_not_found if minibootcamp_frontend_question.nil?

          FrontendQuestion.destroy(minibootcamp_frontend_question.id)
          render_success({ message: 'Frontend Question Deleted Successfully' })
        end
      end
    end
  end
end
