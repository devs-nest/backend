module Api
  module V1
    class OrganizationController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def fetch_by_slug
        organization = Organization.find_by(slug: params[:slug])
        return render_not_found if organization.nil?

        render_success(organization)
      end
    end
  end
end
