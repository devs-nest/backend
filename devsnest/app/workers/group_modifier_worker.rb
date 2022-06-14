# frozen_string_literal: true

# worker that appends tokens to a message
class GroupModifierWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 2
  def perform(action, group_name, guild_id = ENV['DISCORD_GUILD_ID'])
    data = {
      guild_id: guild_id,
      action: action,
      group_name: group_name
    }
    AwsSqsWorker.perform_async('group_modifier', data)
  end
end
