# frozen_string_literal: true

module Api
  module V1
    class FrontendProjectController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      before_action :edit_access, only: %i[show update destroy]

      def show
        render_success({ id: @frontend_project.id, type: 'frontend_project', frontend_project: @frontend_project })
      end

      def index
        user = User.find_by(id: params[:user_id])
        return render_not_found if user.nil?

        render_success({ id: user.id, type: 'frontend_project', frontend_project: user.frontend_projects })
      end

      def create
        frontend_project_params = params[:data][:attributes].permit(%i[name template public]).to_h
        frontend_project = FrontendProject.create!(frontend_project_params.merge({ 'user_id': @current_user.id }))
        template_files = params.dig(:data, :attributes, 'template-files')
        if template_files.present?
          template_files.each do |filename, filecontent|
            FrontendProject.post_to_s3(@current_user.id, frontend_project.name, filename, filecontent)
          end
        end
        api_render(201, { id: frontend_project.id, type: 'frontend_project', frontend_project: frontend_project })
      end

      def update
        frontend_project_params = params[:data][:attributes].permit(%i[name template public]).to_h
        @frontend_project.update!(frontend_project_params)
        template_files = params.dig(:data, :attributes, 'template-files')
        if template_files.present?
          template_files.each do |filename, filecontent|
            FrontendProject.post_to_s3(@current_user.id, @frontend_project.name, filename, filecontent)
          end
        end
        render_success({ id: @frontend_project.id, type: 'frontend_project', frontend_project: @frontend_project })
      end

      def destroy
        @frontend_project.destroy
        render_success({ id: nil, type: 'frontend_project', message: 'Frontend Project Successfully Deleted' })
      end

      def edit_access
        @frontend_project = FrontendProject.where(name: params[:id], user_id: @current_user.id).first
        return render_not_found unless @frontend_project.present?

        return render_unauthorized if params[:user_id].to_i != @frontend_project.user_id

        true
      end
    end
  end
end
