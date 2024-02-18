# frozen_string_literal: true

module Api
  module V1
    module Admin
      # LanguageChallengeMapping Controller for Admin
      class LanguageChallengeMappingController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def index
          challenge_id = params[:challenge_id]
          return render_error('challenge_id is required!') if challenge_id.nil?

          language_challenge_mapping = LanguageChallengeMapping.where(challenge_id: challenge_id)
          render_success({ data: language_challenge_mapping })
        end
      end
    end
  end
end
