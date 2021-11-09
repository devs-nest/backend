# frozen_string_literal: true

module Api
  module V1
    module Admin
      # InternalFeedback Controller for Admin
      class CertificationController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            user: @current_user
          }
        end

        def create
          certification_file = params['certification_file'].tempfile

          invalid_discord_ids = Certification.make_certifications(certification_file)
          api_render(201, { invalid_discord_ids: invalid_discord_ids })
        end
      end
    end
  end
end
