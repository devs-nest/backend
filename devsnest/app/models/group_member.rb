# frozen_string_literal: true

class GroupMember < ApplicationRecord
  audited
  belongs_to :group
  after_create :send_all_steps_completed_mail

  def send_all_steps_completed_mail
    user = User.find_by(id: user_id)
    template_id = EmailTemplate.find_by(name: 'all_steps_completed_mail')&.template_id
    if GroupMember.find_by(user_id: user.id).nil? && user.web_active && user.is_fullstack_course_22_form_filled
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token
                                      }, template_id)
    end
  end
end
