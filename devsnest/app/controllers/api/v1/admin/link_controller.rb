# frozen_string_literal: true

module Api
  module V1
    module Admin
      # link controller for urls
      class LinkController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end
