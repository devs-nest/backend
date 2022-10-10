# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Devsnest <no-reply@devsnest.in>'
  layout 'mailer'
end
