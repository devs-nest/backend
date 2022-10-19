# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  bot_details :string(255)
#  bot_type    :integer
#  event_type  :string(255)
#  message     :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Event < ApplicationRecord
  enum bot_type: %i[generic user]
  VERIFIED = 'verification'
  WELCOME = 'welcome'
  MASS_NOTIFICATION = 'mass_notification'

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
