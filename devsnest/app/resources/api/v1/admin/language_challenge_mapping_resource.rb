# frozen_string_literal: true

module Api
  module V1
    module Admin
      class LanguageChallengeMappingResource < JSONAPI::Resource
        attributes :challenge_id, :language_id
      end
    end
  end
end
