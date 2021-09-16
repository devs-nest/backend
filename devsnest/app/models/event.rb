# frozen_string_literal: true

# triggers an event to be verified
class Event < ApplicationRecord
  enum bot_type: %i[generic user]
  VERIFIED = 'verification'
  NOTIFICATION = 'notification'

  def self.generate(event_type, user)
    event = Event.find_by(event_type: event_type)

    bot = event.bot_type == 'generic' ? 'generic' : NotificationBot.find_by(id: user.bot_id).bot_token

    data = {
      bot: bot,
      message: event.message,
      discord_id: user.discord_id
    }

    AwsSqsWorker.perform_async(event_type, data)
  end
end
