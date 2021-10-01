# frozen_string_literal: true

# worker that appends tokens to a message
class MassNotifierWorker
  include Sidekiq::Worker

  def perform(event_message)
    start = 0
    bucket_size = 20
    while start * NotificationBot.count * bucket_size <= User.count
      NotificationBot.all.each do |bot|
        discord_ids = User.where(bot_id: bot.id).slice(start * bucket_size, bucket_size)
        next unless discord_ids.present?

        data = {
          bot: bot.bot_token,
          message: event_message,
          discord_id: discord_ids.pluck(:discord_id)
        }

        AwsSqsWorker.perform_async('mass_notification', data)
      end
      start += 1

    end
  end
end
