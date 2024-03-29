# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :web_active, :username, :score, :discord_active, :batch, :grad_status, :grad_specialization, :grad_year, :grad_start, :grad_end,
                 :github_url, :linkedin_url, :resume_url, :dob, :registration_num, :colleges, :image_url, :google_id, :bot_token, :update_count, :login_count, :discord_id, :is_verified,
                 :working_status, :is_fullstack_course_22_form_filled, :phone_number, :working_role, :company_name, :college_year, :is_college_form_filled, :accepted_in_course,
                 :enrolled_for_course_image_url, :referral_code, :coins, :github_token, :is_college_student, :dn_airtribe_student
      attributes :group_id, :group_name, :group_version
      attributes :solved, :total_by_difficulty, :fe_solved, :fe_total_by_topic
      attributes :activity
      attributes :discord_username, :school, :work_exp, :known_from, :dsa_skill, :webd_skill, :is_discord_form_filled
      attributes :frontend_activity
      attributes :markdown, :bio
      attributes :type, :user_group_slug
      attributes :batch_leader_details, :user_group_details, :referred_by_code, :current_module
      attributes :dsa_rank, :fe_rank
      attributes :dsa_streak

      def markdown
        @model.markdown.dup.encode('ISO-8859-1').force_encoding('utf-8') unless @model.markdown.blank?
      end

      def fetchable_fields
        context[:user].present? && context[:user].id == @model.id ? super - %i[password] : super - %i[password email phone_number discord_username discord_id]
      end

      def self.updatable_fields(context)
        super - %i[score group_id group_name discord_id password coins]
      end

      def group_id
        member = GroupMember.find_by(user_id: @model.id)
        member.present? ? member.group_id : nil
      end

      def group_name
        member = GroupMember.where(user_id: @model.id).first
        member.present? ? member.group&.name : nil
      end

      def colleges
        # Add all verified colleges in case of admin users
        list_of_colleges = @model.admin? ? College.where(is_verified: true) : []
        college_ids = @model.college_profile.pluck(:college_id)
        list_of_colleges += College.where(id: college_ids)

        list_of_colleges.uniq.collect do |college|
          {
            id: college&.id,
            slug: college&.slug,
            name: college&.name
          }
        end
      end

      def group_version
        member = GroupMember.where(user_id: @model.id).first
        member.present? ? member.group&.version : nil
      end

      def solved
        Challenge.count_solved(@model.id)
      end

      def fe_solved
        FrontendChallenge.count_solved(@model.id)
      end

      def fe_total_by_topic
        FrontendChallenge.split_by_topic
      end

      def total_by_difficulty
        Challenge.split_by_difficulty
      end

      def activity
        @model.activity
      end

      def frontend_activity
        FrontendSubmission.where(user_id: @model.id).group('DATE(updated_at)').count
      end

      def type
        return nil unless @model.user_type != 1

        @model.user_type
      end

      def user_group_slug
        user_group_id = GroupMember.find_by(user_id: @model.id)&.group_id
        return nil if user_group_id.nil?

        Group.find_by(id: user_group_id).try(:slug)
      end

      def batch_leader_details
        group_details = Group.where(batch_leader_id: @model.id)
        group_details.present? ? group_details.as_json : nil
      end

      def user_group_details
        groups = []
        GroupMember.where(user_id: @model.id).includes(:group).each do |group_member|
          groups << group_member.group
        end
        groups.as_json
      end

      def referred_by_code
        Referral.find_by(referred_user_id: @model.id).try(:referral_code)
      end

      def current_module
        course = Course.first # Adding Course.first for handling old groups
        course.try(:current_module)
      end

      def dsa_rank
        @model.leaderboard_details('dsa')
      end

      def fe_rank
        @model.leaderboard_details('frontend')
      end

      def dsa_streak
        @model.dsa_streak
      end
    end
  end
end
