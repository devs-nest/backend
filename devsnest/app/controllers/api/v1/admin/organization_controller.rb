# frozen_string_literal: true

module Api
  module V1
    module Admin
      class OrganizationController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def create
          organization_params = params[:data][:attributes]
          Organization.create(organization_params.merge(slug: organization_params[:name].parameterize.to_s).permit!)
          render_success(id: Organization.last.id, message: 'Organization created successfully')
        end
      end
    end
  end
end
