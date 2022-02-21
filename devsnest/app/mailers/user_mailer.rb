# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def password_reset(user, encrypted_code)
    @user = user
    @uid = encrypted_code
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(to: @user.email, subject: 'Password Reset!')
  end

  def verification(user, encrypted_code)
    @user = user
    @uid = encrypted_code
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(to: @user.email, subject: 'Verify your mail!')
  end
end
