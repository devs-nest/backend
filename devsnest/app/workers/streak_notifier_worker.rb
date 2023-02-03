# frozen_string_literal: true

# worker changes streak of an User
class StreakNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform
    users = User.where('web_active = true and dsa_streak = 0 and streak_end_date between  ? and ?', 4.day.ago, 3.day.ago)
    template_id = EmailTemplate.find_by(name: 'registration_mail')&.template_id
    users.each do |user|
      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'username': user.username,
                                        'last_streak': user.last_streak,
                                        'streak_end_date': user.streak_end_date
                                      }, template_id)
    end
  end
end
