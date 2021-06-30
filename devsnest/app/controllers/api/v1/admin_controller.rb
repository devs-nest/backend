# frozen_string_literal: true

module Api
  module V1
    # admin methods
    class AdminController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth
      before_action :admin_auth

      def onboard_details
        @onboards = Onboard.all
        response.headers['Content-Type'] = 'text/csv; charset=UTF-8; header=present'
        response.headers['Content-Disposition'] = 'attachment; filename=onboard_result.csv'
        render plain: @onboards.to_csv
      end
    end
  end
end
