# frozen_string_literal: true

namespace :registration_mail do
  task data: :environment do
    unsub_user_ids = Unsubscribe.get_by_cache
    User.where.not(id: unsub_user_ids).where(is_fullstack_course_22_form_filled: true, accepted_in_course: false).each do |u|
      template_id = EmailTemplate.find_by(name: 'fullstack_course_22_waitlist').template_id
      EmailSenderWorker.perform_async(u.email, {
                                        'unsubscribe_token': u.unsubscribe_token,
                                        'mass_emailer': true
                                      }, 'd-d9ebbec967cf4470857f1a91fd601b6c')
      u.update!(accepted_in_course: true)
      puts u.username
    rescue StandardError => e
      puts e, u.username
    end
  end
end
