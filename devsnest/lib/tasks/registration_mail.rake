# frozen_string_literal: true

namespace :registration_mail do
  task data: :environment do
    User.all.where(is_fullstack_course_22_form_filled: true, discord_active: true, accepted_in_course: false).each do |u|
      EmailSenderWorker.perform_async(u.email, {
                                        'unsubscribe_token': u.unsubscribe_token
                                      }, 'd-dcbbcc30a3f84e7fa850766648d16f6b')
      u.update!(accepted_in_course: true)
      puts u.username
    rescue StandardError => e
      puts e, u.username
    end
  end
end
