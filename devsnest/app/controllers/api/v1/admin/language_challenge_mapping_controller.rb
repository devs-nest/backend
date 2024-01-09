# frozen_string_literal: true

module Api
  module V1
    module Admin
      # LanguageChallengeMapping Controller for Admin
      class LanguageChallengeMappingController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth
      end
    end
  end
end
