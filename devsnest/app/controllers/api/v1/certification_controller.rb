# frozen_string_literal: true

module Api
  module V1
    # Controller for Certifications
    class CertificationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :change_cuid_to_id, only: %i[show]

      def context
        { user: @current_user }
      end

      def change_cuid_to_id
        certificate = Certification.where(cuid: params[:id])
        if certificate.present?
          params[:id] = certificate.first.id
        else
          render_not_found
        end
      end
    end
  end
end
