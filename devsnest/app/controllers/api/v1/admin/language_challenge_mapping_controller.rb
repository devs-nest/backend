# frozen_string_literal: true

module Api
  module V1
    module Admin
      # LanguageChallengeMapping Controller for Admin
      class LanguageChallengeMappingController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def index
          challenge = Challenge.find_by_id(params[:challenge_id])
          return render_not_found('challenge') if challenge.nil?

          language_challenge_mapping = LanguageChallengeMapping.where(challenge_id: challenge.id).includes(:language).map do |record|
            record.attributes.merge(language_name: record.language.name)
          end
          render_success({ data: language_challenge_mapping })
        end
      end
    end
  end
end
