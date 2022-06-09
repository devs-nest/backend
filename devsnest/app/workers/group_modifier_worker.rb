# frozen_string_literal: true

# worker that appends tokens to a message
class GroupModifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2
  def perform(action, group_name, server_guild_id = nil)
    group = Group.find_by(name: group_name[0])
    guild_id = if server_guild_id.present?
                 server_guild_id
               elsif group.present?
                 group.server.guild_id
               else
                 ENV['DISCORD_GUILD_ID']
               end

    data = {
      guild_id: guild_id,
      action: action,
      group_name: group_name
    }
    AwsSqsWorker.perform_async('group_modifier', data)
  end
end
