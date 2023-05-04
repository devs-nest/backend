# frozen_string_literal: true

# worker sends mail to user with streak
class StreakNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform
    unsub_user_ids = Unsubscribe.get_by_cache
    users = User.where.not(id: unsub_user_ids).where('web_active = true and dsa_streak > 0')
    template_id = EmailTemplate.find_by(name: 'streak_notifier_lm_17')&.template_id
    users.each do |user|
      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'last_streak': user.dsa_streak,
                                        'mass_emailer': true
                                      }, template_id)
    end
  end
end
