# frozen_string_literal: true

# worker changes streak of an User
class StreakBreakWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform
    unsub_user_ids = Unsubscribe.get_by_cache
    users = User.where.not(id: unsub_user_ids).where('web_active = true and dsa_streak = 0 and last_dsa_streak > 0 and streak_end_date = ?', DateTime.yesterday.to_date - 1.days)
    template_id = EmailTemplate.find_by(name: 'streak_breaker_lm_16')&.template_id
    users.each do |user|
      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'username': user.username,
                                        'last_streak': user.last_dsa_streak,
                                        'streak_end_date': user.streak_end_date,
                                        'mass_emailer': true
                                      }, template_id)
    end
  end
end
