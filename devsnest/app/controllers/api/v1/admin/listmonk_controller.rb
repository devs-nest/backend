module Api
  module V1
    module Admin
      # link controller for urls
      class ListmonkController < ApplicationController
        include JSONAPI::ActsAsResourceController
        # before_action :admin_auth
        require 'csv_handler/csv_helper.rb'

        def list
          headers = ['email','name']
          condition = params['condition'] 
          atr = params['attributes']

          render_error('No condition given') if condition.blank?

          res = eval(condition)
          render_unprocessable unless res.try(:sample).is_a?(User)

          response.headers['Content-Type'] = 'text/csv; charset=UTF-8; header=present'
          response.headers['Content-Disposition'] = 'attachment; filename=list_result.csv'
          render plain: CsvHelper.new(res, fields: headers).call
        end
      end
    end
  end
end
