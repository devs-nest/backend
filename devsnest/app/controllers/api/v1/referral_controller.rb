# frozen_string_literal: true

module Api
  module V1
    # controller for the Referrals
    class ReferralController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        user = @current_user
        referrals = []
        Referral.where(referral_code: user.referral_code).each do |u|
          referred_user = User.find(u&.user_id)
          referrals.push({ referred_user: referred_user.name, created_at: u.created_at }).as_json if referred_user.present?
        end
        data = referrals.sort_by { |hsh| hsh[:created_at] }.reverse
        api_render(200, { type: 'referrals', attributes: data })
      end
    end
  end
end
