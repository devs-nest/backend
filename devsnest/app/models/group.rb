# frozen_string_literal: true

# Model for Group
class Group < ApplicationRecord
  # belongs_to :batch
  audited
  has_many :group_members
  after_create :parameterize
  after_commit :parameterize, if: :saved_change_to_name?
  validates :members_count, numericality: { less_than_or_equal_to: 16, :message => 'The group is full' }
  validates :members_count, numericality: { greater_than_or_equal_to: 0, :message => 'The group members count can\'t be negetive' }
  enum group_type: %i[public private], _prefix: :group
  enum language: %i[english hindi]
  enum classification: %i[students professionals]

  scope :v1, -> { where(version: 1) }
  scope :v2, -> { where(version: 2) }
  scope :visible, -> { where(group_type: 'public')}
  scope :under_12_members, -> { where('members_count < 12')}

  def parameterize
    update_attribute(:slug, name.parameterize)
  end

  def reassign_leader(user_id)
    if owner_id == user_id
      if co_owner_id.nil? && group_members.count > 0
        promote_member_id = group_members.pluck(:id).sample
        update(owner_id: promote_member_id)
      elsif co_owner_id.present?
        update(owner_id: co_owner_id, co_owner_id: nil)
      else
        disband_group
      end
    elsif co_owner_id == user_id
      update(co_owner_id: nil)
    end
  end

  def disband_group
    destroy
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
