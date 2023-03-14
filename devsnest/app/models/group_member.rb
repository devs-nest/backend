# frozen_string_literal: true

# == Schema Information
#
# Table name: group_members
#
#  id                :bigint           not null, primary key
#  members_count     :integer
#  owner             :boolean
#  scrum_master      :boolean
#  student_mentor    :boolean
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  batch_id          :integer
#  group_id          :integer
#  student_mentor_id :integer
#  user_id           :integer
#
# Indexes
#
#  index_group_members_on_user_id               (user_id)
#  index_group_members_on_user_id_and_group_id  (user_id,group_id) UNIQUE
#
class GroupMember < ApplicationRecord
  include UtilConcern
  audited
  belongs_to :group
  after_create :send_all_steps_completed_mail
  after_create :set_prevoiusly_joined_a_group
  after_create :send_scrum_message_in_group
  after_save :update_previous_scrum
  # after_commit :cache_expire
  after_commit :update_group_member_count, only: %i[create destroy]
  has_paper_trail on: %i[destroy]

  def update_group_member_count
    return if group.group_members.count.zero?

    group.update(members_count: group.group_members.count)
  end

  def send_all_steps_completed_mail
    user = User.find_by(id: user_id)
    template_id = EmailTemplate.find_by(name: 'all_steps_completed_mail')&.template_id
    if user.previously_joined_a_group == false && user.web_active && user.is_fullstack_course_22_form_filled
      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'username': user.username
                                      }, template_id)
    end
  end

  # setting value to true in user when a user joins a group :)
  def set_prevoiusly_joined_a_group
    user = User.find_by(id: user_id)
    user.update(previously_joined_a_group: true)
  end

  def send_scrum_message_in_group
    group = Group.find_by(id: group_id)
    ping_discord(group, 'Initialize_Group_Scrum') if group.group_members.count == 5 && group.five_members_flag == false
    group.update(five_members_flag: true) if group.members_count >= 5
  end

  def update_previous_scrum
    Scrum.where(user_id: user_id).update_all(group_id: group_id) if saved_change_to_attribute?(:group_id)
  end

  def cache_expire
    group.touch if group.persisted?
  end
end
