# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :name, :password, :web_active, :username, :score, :discord_active, :batch, :grad_status, :grad_specialization, :grad_year, :grad_start, :grad_end,
                 :github_url, :linkedin_url, :resume_url, :dob, :registration_num, :college_id, :image_url, :google_id, :bot_token, :update_count, :login_count
      attributes :group_id, :group_name
      attributes :college_name
      attributes :solved, :total_by_difficulty
      attributes :activity

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
        return nil if context[:user].nil?

        member = GroupMember.where(user_id: context[:user].id).first
        member.present? ? member.group.name : nil
      end

      def college_name
        user = User.find_by(id: id)
        return nil if user.nil?

        user.reload
        return nil if user.college_id.nil?

        College.find_by(id: user.college_id).name
      end

      def solved
        user = User.find_by(id: id)
        return nil if user.nil?

        Submission.count_solved(user.id)
      end

      def total_by_difficulty
        user = User.find_by(id: id)
        return nil if user.nil?

        Content.split_by_difficulty
      end

      def activity
        user = User.find_by(id: id)
        return nil if user.nil?

        Submission.user_activity(user)
      end
    end
  end
end
