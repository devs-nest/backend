# frozen_string_literal: true

# worker that appends tokens to a message
class MassRoleModifierWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 2
  def perform(action, discord_ids, role_name, server_guild_id = ENV['DISCORD_GUILD_ID'])
    guild_id = group_guild_id(role_name, server_guild_id)
    discord_ids.each_slice(100) do |ids|
      data = {
        guild_id: guild_id,
        action: action,
        discord_ids: ids,
        role_name: role_name
      }
      AwsSqsWorker.perform_async('role_modifier', data)
    end
  end
end
