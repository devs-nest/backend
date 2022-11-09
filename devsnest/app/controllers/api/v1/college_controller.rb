# frozen_string_literal: true

module Api
  module V1
    class CollegeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :college_admin_auth, only: %i[index]
      # TODO: add college auth

      def invite
        return render_error("Domain mismatched") if College.domains_matched?(@current_college_user.college_profile.email, params[:email])
 
        data_to_encode = {
          email: params[:email],
          initiated_at: Time.now
        }
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)
        college_profile = CollegeProfile.create(email: params[:email], college: @current_college_user.college_profile.college, authority_level: params[:authority_level])
        CollegeInvite.create(college_profile: college_profile, uid: encrypted_code)

        render_success(message: "Invite sent")
      end

      def join
        code = params["code"]
        invite_entitiy = CollegeInvite.find_by_uid(code)
        return render_error("Invalid code") if invite_entitiy.blank? || invite_entitiy.status != 'pending'
        return render_error("Invalid password") if params[:password].blank?

        invite_entitiy.update(status: 'closed')
        user = User.create!(
          name: params[:name],
          username: params[:username],
          email: invite_entitiy.college_profile.email,
          password: params[:password],
          web_active: true,
          is_verified: true
        )

        invite_entitiy.college_profile.update(user: user)

        # TODO send email
      end
    end
  end
end
