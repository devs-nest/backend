# frozen_string_literal: true

module Api
  module V1
    module Admin
      # link controller for urls
      class LinkController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def update
          slug = params[:data][:attributes][:slug]
          address = params[:data][:attributes][:address]
          Link.find_by(slug: slug).update(address: address)
        end
      end
    end
  end
end
