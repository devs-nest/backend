# frozen_string_literal: true

module Api
  module V1
    class CollegeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :set_current_college_user
      before_action :college_admin_auth, only: %i[show invite]
      before_action :check_college_verification

      def context
        { user: @current_college_user }
      end

      def invite
        return render_error("Domain mismatched") if College.domains_matched?(@current_college_user.college_profile.email, params[:email])
 
        data_to_encode = {
          email: params[:email],
          initiated_at: Time.now
        }
        college_id = @current_college_user.college_profile.college.id
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)
        college_profile = CollegeProfile.create!(email: params[:email], college_id: college_id, authority_level: params[:authority_level], department: params[:department])
        CollegeInvite.create!(college_profile: college_profile, uid: encrypted_code, college_id: college_id)

        template_id = EmailTemplate.find_by(name: 'college_join')&.template_id
        EmailSenderWorker.perform_async(params[:email], {
                                          code: data_to_encode
                                        }, template_id)
        render_success(message: "Invite sent")
      end

      def join
        invite_entitiy = CollegeInvite.find_by_uid(params[:code])

        return render_error("Invalid code") if invite_entitiy.blank? || invite_entitiy.status != 'pending'
        return render_error("Invalid password") if params[:password].blank?
        
        email = invite_entitiy.college_profile.email
        
        code = $cryptor.decrypt_and_verify(params[:code])
        return render_error('Invite code tempered') if email != code[:email]
        user = User.find_by(email: email)

        user = User.create!(
          name: params[:name],
          email: email,
          password: params[:password],
          web_active: true,
          is_verified: true
        ) if user.blank?
          
        invite_entitiy.update(status: 'closed')
        invite_entitiy.college_profile.update(user: user)

        render_success(message: "College joined")
      end
    end
  end
end
