# frozen_string_literal: true

module Api
  module V1
    class CompanyController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index]
      before_action :admin_auth, only: %i[create]
    end
  end
end
