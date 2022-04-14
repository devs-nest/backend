# frozen_string_literal: true

# send mails using SendGrid
class EmailSenderWorker
  include Sidekiq::Worker

  def perform(receiver_email, meta_data, template_id)
    SendgridMailer.send(receiver_email, meta_data, template_id)
  end
end
