# frozen_string_literal: true

# worker that appends tokens to a message
class RoleModifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(action, discord_id, role_name, server_guild_id = nil)
    guild_id = group_guild_id(role_name, server_guild_id)
    data = {
      guild_id: guild_id,
      action: action,
      discord_id: discord_id,
      role_name: role_name
    }
    AwsSqsWorker.perform_async('role_modifier', data)
  end
end
