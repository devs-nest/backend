module Api
  module V1
    module Admin
      class OrganizationController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end