# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Reward Resource
      class RewardResource < JSONAPI::Resource
        attributes :title, :description
      end
    end
  end
end
