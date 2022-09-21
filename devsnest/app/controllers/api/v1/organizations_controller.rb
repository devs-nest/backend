module Api
  module V1
    class OrganizationsController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end
