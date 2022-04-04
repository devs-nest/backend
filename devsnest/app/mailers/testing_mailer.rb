class TestingMailer < ApplicationMailer
  def send_testing_email
    mail( :to => 'yug.gurnani091@gmail.com',
    :subject => 'Thanks for testing up for our amazing app' )
  end
end