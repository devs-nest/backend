# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Projects admin resource
      class ProjectResource < JSONAPI::Resource
        attributes :banner, :challenge_details, :challenge_id, :challenge_type, :intro

        def challenge_details
          @model.challenge_data
        end
      end
    end
  end
end
