# frozen_string_literal: true

module Api
  module V1
    module Admin
      class CollegeFormController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth, only: %i[index]
      end
    end
  end
end
