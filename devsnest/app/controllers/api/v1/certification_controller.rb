# frozen_string_literal: true

module Api
  module V1
    # Controller for Certifications
    class CertificationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :change_uuid_to_id, only: %i[show]

      def context
        { user: @current_user }
      end

      def change_uuid_to_id
        if Certification.where(uuid: params[:id]).present?
          params[:id] = Certification.where(uuid: params[:id]).first.id
        else
          render_not_found
        end
      end
    end
  end
end
