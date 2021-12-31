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
    end
  end
end
