# frozen_string_literal: true

# == Schema Information
#
# Table name: event_registrations
#
#  id           :bigint           not null, primary key
#  user_data    :json
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  edu_event_id :integer
#  user_id      :integer
#
class EventRegistration < ApplicationRecord
  belongs_to :edu_event
  belongs_to :user

  after_create :send_event_registration_mail

  def send_event_registration_mail
    if edu_event.organizer == 'Solana'
      template_id = EmailTemplate.find_by(name: 'solana_registration_lm').try(:template_id)
      return if template_id.blank?

      EmailSenderWorker.perform_async(user.email, {
                                        'username': user.name.blank? ? user.username : user.name.titleize
                                      },
                                      template_id)
    end
  end
end
