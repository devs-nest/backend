# frozen_string_literal: true

module Api
  module V1
    module Admin
      # LanguageChallengeMapping Controller for Admin
      class LanguageChallengeMappingController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def destroy
          challenge_id = params.dig(:data, :attributes, :challenge_id)
          language_id = params.dig(:data, :attributes, :language_id)
          LanguageChallengeMapping.destroy_by(challenge_id: challenge_id, language_id: language_id)
          render_success({ message: 'Language Mapping deleted successfully!!' })
        end
      end
    end
  end
end
