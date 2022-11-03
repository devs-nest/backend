# frozen_string_literal: true

# send mails using SendGrid
class EmailSenderWorker
  include Sidekiq::Worker

  def perform(receiver_email, meta_data, template_id)
    SendgridMailer.send(receiver_email, meta_data, template_id)
    # puts("Mail sent to #{receiver_email} with template_id #{template_id} and meta_data #{meta_data}")
    User.find_by(email: receiver_email)&.update(accepted_in_course: true) if meta_data['user_accepted']
  end
end
