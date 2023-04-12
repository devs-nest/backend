# frozen_string_literal: true

# worker notifies streak break of an User
class StreakBreakNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform
    unsub_user_ids = Unsubscribe.get_by_cache
    users = User.where.not(id: unsub_user_ids).where('web_active = true and last_dsa_streak > 0 and streak_end_date = ?', DateTime.yesterday.to_date)
    template_id = EmailTemplate.find_by(name: 'streak_break_notifier')&.template_id
    ucs_batch = UserChallengeScore.where(user_id: users.pluck(:id))
    users.each do |user|
      user_question_list = ucs_batch.where(user_id: user.id).pluck(:challenge_id)
      challenge = Challenge.where(is_active: true).where.not(id: user_question_list).sample(1)
      next unless challenge.present?

      EmailSenderWorker.perform_async(user.email, {
                                        'unsubscribe_token': user.unsubscribe_token,
                                        'username': user.username,
                                        'question': challenge[0].name,
                                        'module': 'Data Structure',
                                        'difficulty': challenge[0].difficulty,
                                        'question_link': "https://devsnest.in/algo-challenges/#{challenge[0].slug}?tab=question",
                                        'mass_emailer': true
                                      }, template_id)
    end
  end
end
