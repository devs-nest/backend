# frozen_string_literal: true

# worker that send message to an User
class UserNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(discord_id, event_message)
    user = User.find_by(discord_id: discord_id)
    return unless user.present?

    data = {
      bot_id: user.bot_id, message: event_message,
      discord_id: [discord_id]
    }

    AwsSqsWorker.perform_async('notification', data, ENV['SQS_NOTIFIER_URL'])
  end
end
