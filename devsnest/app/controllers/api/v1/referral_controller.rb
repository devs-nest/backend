# frozen_string_literal: true

module Api
  module V1
    # controller for the Referrals
    class ReferralController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        referral_type = params[:referral_type] || 'devsnest_registration'
        user_referrals = Referral.where(referral_code: @current_user.referral_code, referral_type: referral_type)
        referrals = { referrals: [] }
        user_referrals.each do |q|
          if referral_type == 'devsnest_registration'
            referred_user = User.get_by_cache(q.referred_user_id)
            next if referred_user.blank?

            referrals[:referrals].push({ id: referred_user.id, referred_user: referred_user.name, registered_for_the_course: referred_user.is_fullstack_course_22_form_filled,
                                         is_discord_connected: referred_user.discord_active, created_at: q.created_at })
          else
            college_student = CollegeStudent.find_by(user_id: q.referred_user_id)
            referrals[:referrals].push({
                                         name: college_student.name, email: college_student.email, state: college_student.state,
                                         created_at: college_student.created_at
                                       }) if college_student.present?
          end
        end

        referrals[:referrals] = referrals[:referrals].sort_by { |hsh| hsh[:created_at] }.reverse
        if referrals.present?
          api_render(200, referrals.merge(type: 'referrals'))
        else
          render_error(message: 'No referrals found', status: 404)
        end
      end
    end
  end
end
