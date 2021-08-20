# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :web_active, :username, :score, :discord_active, :batch, :grad_status, :grad_specialization, :grad_year, :grad_start, :grad_end,
                 :github_url, :linkedin_url, :resume_url, :dob, :registration_num, :college_id, :image_url, :google_id, :bot_token, :update_count, :login_count, :discord_id
      attributes :group_id, :group_name
      attributes :college_name
      attributes :solved, :total_by_difficulty
      attributes :activity
      attributes :discord_username, :school, :work_exp, :known_from, :dsa_skill, :webd_skill, :is_discord_form_filled
      attributes :frontend_activity
      attributes :markdown, :bio

      def markdown
        @model.markdown.dup.encode('ISO-8859-1').force_encoding('utf-8') unless @model.markdown.blank?
      end

      def fetchable_fields
        if context[:user].nil? || context[:user].id == @model.id
          super - %i[password]
        else
          super - %i[password email]
        end
      end

      def self.updatable_fields(context)
        super - %i[score group_id group_name discord_id password college_name]
      end

      def group_id
        return nil if context[:user].nil?

        member = GroupMember.where(user_id: context[:user].id).first
        member.present? ? member.group_id : nil
      end

      def group_name
        member = GroupMember.where(user_id: @model.id).first
        member.present? ? member.group.name : nil
      end

      def college_name
        return nil if @model.college.nil?

        @model.college.name
      end

      def solved
        Submission.count_solved(@model.id)
      end

      def total_by_difficulty
        Content.split_by_difficulty
      end

      def activity
        Submission.user_activity(@model)
      end

      def frontend_activity
        FrontendSubmission.where(user_id: @model.id).group('DATE(updated_at)').count
      end
    end
  end
end
