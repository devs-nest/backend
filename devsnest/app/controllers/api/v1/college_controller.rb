# frozen_string_literal: true

module Api
  module V1
    class CollegeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :set_current_college_user, except: %i[create]
      before_action :college_admin_auth, only: %i[show invite structure_schema structure]
      before_action :user_auth, only: %i[create]
      before_action :check_college_verification, only: %i[show invite join]

      def context
        { user: @current_college_user, college: @current_college_user&.college }
      end

      def create
        return render_unauthorized('Already a college member or already submitted a request') if @current_user.college_profile.present?

        data = params.dig(:data, :attributes)
        ActiveRecord::Base.transaction do
          college = College.create!(name: data[:name])
          CollegeProfile.create(user_id: @current_user.id, college_id: college.id, email: data[:email] || @current_user.email, authority_level: 0)
        end
        render_success(message: 'Request submitted')
      rescue StandardError => e
        render_error("Something went wrong: #{e}")
      end

      def create
        return render_unauthorized("Already a college member or already submitted a request") if @current_user.college_profile.present?
        
        data = params.dig(:data, :attributes)
        ActiveRecord::Base.transaction do
          college = College.create!(name: data[:name])
          CollegeProfile.create(user_id: @current_user.id, college_id: college.id, email: data[:email] || @current_user.email, authority_level: 0)
        end
        render_success(message: 'Request submitted')
      rescue StandardError => e
        render_error("Something went wrong: #{e}")
      end

      def create
        return render_unauthorized("Already a college member or already submitted a request") if @current_user.college_profile.present?
        
        data = params.dig(:data, :attributes)
        ActiveRecord::Base.transaction do
          college = College.create!(name: data[:name])
          CollegeProfile.create(user_id: @current_user.id, college_id: college.id, email: data[:email] || @current_user.email, authority_level: 0)
        end
        render_success(message: 'Request submitted')
      rescue StandardError => e
        render_error("Something went wrong: #{e}")
      end

      def invite
        data = params.dig(:data, :attributes)
        return render_error('Domain mismatched') if College.domains_matched?(@current_college_user.college_profile.email, data[:email])

        data_to_encode = {
          email: data[:email],
          initiated_at: Time.now
        }

        college_id = @current_college_user.college.id
        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)

        skip_pass = User.find_by_email(data[:email]).blank?

        ActiveRecord::Base.transaction do
          c_struc = CollegeStructure.find_by_name(data[:structure])
          college_profile = CollegeProfile.create!(email: data[:email], college_id: college_id, college_structure_id: c_struc&.id, authority_level: data[:authority_level],
                                                   department: data[:department])
          CollegeInvite.create!(college_profile: college_profile, uid: encrypted_code, college_id: college_id)

          template_id = EmailTemplate.find_by(name: 'college_join')&.template_id
          EmailSenderWorker.perform_async(data[:email], {
                                            collegename: @current_college_user.college.name,
                                            username: data[:email].split("@")[0],
                                            code: encrypted_code,
                                            skip_pass: skip_pass
                                          }, template_id)
        end
        render_success(message: 'Invite sent')
      rescue StandardError => e
        render_error("Something went wrong: #{e}")
      end

      def join
        data = params.dig(:data, :attributes)
        invite_entitiy = CollegeInvite.find_by_uid(data[:code])

        return render_error('Invalid code') if invite_entitiy.blank? || invite_entitiy.status != 'pending'
        return render_error('Invalid password') if data[:password].blank?

        email = invite_entitiy.college_profile.email

        code = $cryptor.decrypt_and_verify(data[:code])
        return render_error('Invite code tempered') if email != code[:email]

        user = User.find_by(email: email)

        ActiveRecord::Base.transaction do
          if user.blank?
            user = User.create!(
              name: data[:name],
              email: email,
              password: data[:password],
              web_active: true,
              is_verified: true
            )
          end

          if invite_entitiy.college_profile.is_admin?
            user.update(user_type: 'college_admin')
          end

          invite_entitiy.update(status: 'closed')
          invite_entitiy.college_profile.update(user: user)
        end

        render_success(message: 'College joined')
      rescue StandardError => e
        render_error("Something went wrong: #{e}")
      end

      def structure_schema
        api_render(200, { data: { schema: CollegeStructure::SCHEMA, structure: CollegeStructure.where(college_id: @current_college_user&.college_profile&.college&.id) } })
      end

      def structure
        data = params.dig(:data, :attributes)
        college = @current_college_user.college_profile.college

        data.each do |course, course_data|
          course_data[:batch].each do |batch|
            start_year, end_year = CollegeStructure.split_batch(batch[:period])
            year = batch[:year] || CollegeStructure.calc_year(start_year, course)
            CollegeStructure.create!(college_id: college.id, course: course, batch: batch[:period], year: year, section: batch[:section], branch: batch[:branch])
          end
        end

        render_success
      end

    end
  end
end
