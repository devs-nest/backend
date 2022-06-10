# frozen_string_literal: true

module Api
  module V1
    # controller for the Referrals
    class ReferralController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        user_referrals = Referral.where(referral_code: @current_user.referral_code)
        referrals = { referrals: [] }
        user_referrals.each do |q|
          referred_user = User.find(q.referred_user_id)
          referrals[:referrals].push({ id: referred_user.id, referred_user: referred_user.name, created_at: q.created_at }) if referred_user.present?
        end
        referrals[:referrals].sort_by { |hsh| hsh[:created_at] }.reverse
        if referrals.present?
          api_render(200, referrals.merge(type: 'referrals'))
        else
          render_error(message: 'No referrals found', status: 404)
        end
      end
    end
  end
end
