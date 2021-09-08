# frozen_string_literal: true

# triggers an event to be verified
class Event < ApplicationRecord
  enum bot_type: %i[generic user]
  VERIFIED = 'verification'
  WELCOME = 'welcome'
  NOTIFICATION = 'notification'

  def self.generate(event_type, user)
    event = Event.find_by(event_type: event_type)

    bot = event.bot_type == 'generic' ? 'generic' : event.bot_details
    user_bot = User.find_by(discord_id: data[:discord_id]).bot_id

    data = {
      bot: bot,
      message: event.message,
      discord_id: user.discord_id
    }

    AwsSqsWorker.perform_async(event_type, data)
  end

  def self.welcome_message(event_type, data)
    event = Event.find_by(event_type: event_type)
    user_bot = User.find_by(discord_id: data[:discord_id]).bot_id
    bot = event.bot_type == 'generic' ? 'user' : user_bot

    data = {
      bot: bot,
      message: event.message,
      discord_id: user.discord_id
    }

    AwsSqsWorker.perform_async(event_type, data)
  end
end
