# frozen_string_literal: true

class Group < ApplicationRecord
  # belongs_to :batch
  has_many :group_members

  def self.update_group_name(user_id, group_name)
    group_member = GroupMember.find_by(user_id: user_id)
    group_id = group_member.group_id
    group = Group.find_by(id: group_id) 
    group.name =  group_name 
    group.save
  end  
  
end
