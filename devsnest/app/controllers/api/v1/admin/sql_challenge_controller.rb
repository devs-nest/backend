# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Controller for Sql Challenge for Admin panel
      class SqlChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def context
          {
            action: params[:action]
          }
        end
      end
    end
  end
end
