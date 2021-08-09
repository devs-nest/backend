# frozen_string_literal: true

# Model for Group
class Group < ApplicationRecord
  # belongs_to :batch
  audited
  has_many :group_members
  after_create :parameterize

  def parameterize
    update_attribute(:slug, name.parameterize)
  end

  def check_auth(user)
    return true if group_members.where(user_id: user.id).present? || batch_leader_id == user.id || user.user_type == 'admin'

    false
  end

  def group_admin_auth(user)
    return true if user.id == owner_id || user.id == co_owner_id || user.user_type == 'admin'

    false
  end

  def admin_rights_auth(user)
    return true if user.id == owner_id || user.id == co_owner_id || user.id == batch_leader_id || user.user_type == 'admin'

    false
  end
end
