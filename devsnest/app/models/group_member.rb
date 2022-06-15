# frozen_string_literal: true

class GroupMember < ApplicationRecord
  audited
  belongs_to :group
  after_create :send_all_steps_completed_mail
  after_create :set_prevoiusly_joined_a_group
  after_create :send_scrum_message_in_group, if: :group_member_count_five?

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

  def group_member_count_five?
    user_group = Group.find_by(id: group_id)
    group_member_count = GroupMember.where(group_id: user_group.id).count
    return true if group_member_count == 5

    false
  end

  def send_scrum_message_in_group
    message = "Hope you are enjoying the Server! \r\nYou can connect with your group here and here, Let's catch up tomorrow for our first meeting and get to know each other.\r\nThe agenda of the meeting will be for you all to decide a daily catchup time that works for you all and choose your goals for the course"
    byebug
    GroupNotifierWorker.perform_async(group.name, message, group.server&.guild_id)
  end
end
