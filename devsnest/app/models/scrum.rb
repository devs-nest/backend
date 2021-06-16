# frozen_string_literal: true

class Scrum < ApplicationRecord
    def self.create_scrum(context, batchmate_user_id, attendance, saw_last_lecture, till_which_tha_you_are_done, what_cover_today,reason_for_backlog)
      user_group_id = GroupMember.find_by(user_id: context[:user].id).group_id
  
      if batchmate_user_id.present?
        batchmate_group_id = GroupMember.find_by(user_id: batchmate_user_id ).group_id
        batchmate_owner_id = Group.find_by(id: batchmate_group_id).owner_id
      end
  
      if batchmate_user_id == nil
        group_id = user_group_id
        group_member = GroupMember.where(user_id: context[:user].id).first
        scrum = Scrum.create(user_id: context[:user].id, group_id: group_id, saw_last_lecture: saw_last_lecture, till_which_tha_you_are_done: till_which_tha_you_are_done, what_cover_today: what_cover_today, reason_for_backlog: reason_for_backlog)
        return scrum
      elsif  context[:user].id == batchmate_owner_id
        group_id = batchmate_group_id
        group_member = GroupMember.where(user_id: batchmate_user_id).first
        scrum = Scrum.create(user_id: batchmate_user_id, group_id: group_id, attendance: attendance, saw_last_lecture: saw_last_lecture, till_which_tha_you_are_done: till_which_tha_you_are_done, what_cover_today: what_cover_today, reason_for_backlog: reason_for_backlog)
        return scrum
      else
        return nil
        end
    end
end