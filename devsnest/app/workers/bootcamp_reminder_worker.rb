# frozen_string_literal: true

# worker that sends reminder mail of bootcamp
class BootcampReminderWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2

  def perform
    bootcamp_progresses = BootcampProgress.includes(:course_curriculum, :user).where(completed: false).where('updated_at < ? && updated_at > ?',
                                                                                                             (Time.zone.now - 2.days).beginning_of_day, (Time.zone.now - 3.days).beginning_of_day)

    bootcamp_progresses.each do |bootcamp_progress|
      puts '----------------------------------------------------'
      puts "Bootcamp Reminder Mail Going #{bootcamp_progress.id}"
      puts '----------------------------------------------------'
      user = bootcamp_progress.user
      template_id = EmailTemplate.find_by(name: 'bootcamp_pending_mail_lm').try(:template_id)
      next if template_id.blank?

      EmailSenderWorker.perform_async(user.email, {
                                        'username': user.name.blank? ? user.username : user.name.titleize,
                                        'course_name': bootcamp_progress.course_curriculum.course_type.upcase
                                      },
                                      template_id)
    end
  end
end
