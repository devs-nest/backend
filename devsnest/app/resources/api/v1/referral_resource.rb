# frozen_string_literal: true

module Api
  module V1
    class ReferralResource < JSONAPI::Resource
      attributes :user_id, :referral_code, :created_at
    end
  end
end
