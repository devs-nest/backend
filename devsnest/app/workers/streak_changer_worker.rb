# frozen_string_literal: true

# worker changes streak of an User
class StreakChangesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform
    users = User.where('web_active = true and dsa_streak > 0')
    users.each do |user|
      if user.streak_end_date < 1.day.ago && user.dsa_streak.positive?
        user.update(last_dsa_streak: user.dsa_streak)
        user.update(dsa_streak: 0)
      end
    end
  end
end
