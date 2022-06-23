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
          referred_user = User.get_by_cache(q.referred_user_id)
          referrals[:referrals].push({ id: referred_user.id, referred_user: referred_user.name, registered_for_the_course: referred_user.is_fullstack_course_22_form_filled,
                                       is_discord_connected: referred_user.discord_active, created_at: q.created_at })
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
