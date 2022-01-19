# frozen_string_literal: true

module Api
  module V1
    class CompanyController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index]

      def challenges
        company = Company.find(params['id'])
        return render_not_found if company.nil?

        render_success({ id: company.id, type: 'challenges', challenges: company.challenges })
      end
    end
  end
end
