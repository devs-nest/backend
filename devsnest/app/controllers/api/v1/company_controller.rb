# frozen_string_literal: true

module Api
  module V1
    class CompanyController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[index]
      before_action :admin_auth, only: %i[create]

      def challenges
        company_ids = params['data']['attributes']['company_ids']
        company_challenges = Challenge.where(id: CompanyChallengeMapping.where(company_id: company_ids).pluck(:challenge_id))

        render_success({ id: nil, type: 'challenges', challenges: company_challenges.as_json })
      end
    end
  end
end
