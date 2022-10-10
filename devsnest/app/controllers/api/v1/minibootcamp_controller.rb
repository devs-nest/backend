# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Cotroller
    class MinibootcampController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def context
        {
          parent_id: params.dig('filter', 'parent_id')
        }
      end

      def menu
        return render_error('Parent Id missing') if params[:parent_id].nil?

        menu_tab = []
        records = Minibootcamp.where(parent_id: params[:parent_id])

        records.each do |record|
          menu_tab << {
            unique_id: record.unique_id,
            name: record.name,
            is_solved: record&.frontend_question&.minibootcamp_submissions&.find_by(user_id: @current_user&.id)&.is_solved
          }
        end

        api_render(200, { type: 'menu', attributes: menu_tab })
      end

      def predefined_templates
        available_templates = %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]
        return render_error('Invalid template request') unless available_templates.include?(params[:type]&.to_sym)

        files = {}
        bucket = "#{ENV['S3_PREFIX']}frontend-templates"
        s3_files = $s3_resource.bucket(bucket).objects(prefix: params[:type]).collect(&:key)

        s3_files.each do |file|
          content = $s3.get_object(bucket: bucket, key: file).body.read
          files.merge!(Hash[file, content])
        end
        api_render(200, { id: 1, type: 'custom_images', files: files })
      end
    end
  end
end
