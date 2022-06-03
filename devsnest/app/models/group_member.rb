# frozen_string_literal: true

class GroupMember < ApplicationRecord
  audited
  belongs_to :group
  after_create :send_all_steps_completed_mail
  after_create :set_prevoiusly_joined_a_group

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
end
