# frozen_string_literal: true

module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :name, :password, :discord_id, :web_active, :username, :score, :discord_active, :batch, :grad_status, :grad_specialization, :grad_year
      attributes :group_id, :group_name 
      attributes :college
      attributes :easy_solved, :medium_solved, :hard_solved
      attributes :activity

      def fetchable_fields
        if context[:user].nil? || context[:user].id == @model.id
          super - [:password]
        else
          super - [:password, :email]
        end
      end

      def group_id
        return nil if context[:user].nil?
        member = GroupMember.where(user_id: context[:user].id).first
        member.present? ? member.group_id : nil
      end

      def group_name
        return nil if context[:user].nil?
        member = GroupMember.where(user_id: context[:user].id).first 
        groupId = member.present? ? member.group_id : nil
        group =  Group.where(id: groupId).first
        group.present? ? group.name : nil
      end

      def college
        return nil if context[:user].nil?
        member = College.where(user_id: context[:user].id).first       
        member.present? ? member.name : nil
      end

      def easy_solved
        return nil if context[:user].nil?
        Submission.count_solved(context[:user].id, "easy")
      end   

      def medium_solved
        return nil if context[:user].nil?
        Submission.count_solved(context[:user].id, "medium")
      end  

      def hard_solved
        return nil if context[:user].nil?
        Submission.count_solved(context[:user].id, "hard")
      end  
      
      def activity
        return nil if context[:user].nil?

        dates = Hash.new
        # should marked as doubt be included too?
        Submission.where(status:"done",user_id:context[:user].id).all.each do |user|
          if dates.key?(user.updated_at.to_date)
            dates[user.updated_at.to_date] += 1
          else
            dates[user.updated_at.to_date] = 1
          end

        end
        return dates
      end


    end
  end
end
