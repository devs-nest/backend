# frozen_string_literal: true

class Group < ApplicationRecord
  # belongs_to :batch
  has_many :group_members
  after_create :parameterize

  def parameterize
    update_attribute(:slug, self.name.parameterize)
  end

  def check_auth(user)
    return true if self.group_members.where(user_id: user.id).present? || self.batch_leader_id == user.id || user.user_type == 'admin'  
    false
  end

  def check_scrum_edit_auth(user)
    return true if user.id == self.owner_id || user.id == self.co_owner_id || user.id == self.batch_leader_id || user.user_type == 'admin'
    false
  end
end
