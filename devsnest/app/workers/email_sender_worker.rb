# frozen_string_literal: true

# send mails using SendGrid
class EmailSenderWorker
  include Sidekiq::Worker

  def perform(receiver_email, meta_data, template_id)
    user = User.find_by_email(receiver_email)
    return if user.blank?

    if meta_data['mass_emailer'].blank?
      unsub_user_ids = Unsubscribe.get_by_cache
      return if unsub_user_ids.include?(user.id)
    end

    ListmonkMailer.send(receiver_email, meta_data, template_id.to_i)
    user.update(accepted_in_course: true) if meta_data['user_accepted']
  end
end
