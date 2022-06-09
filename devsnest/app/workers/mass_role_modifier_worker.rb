# frozen_string_literal: true

# worker that appends tokens to a message
class MassRoleModifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2
  def perform(action, discord_ids, role_name, server_guild_id = nil)
    group = Group.find_by(name: role_name)
    guild_id = if server_guild_id.present?
                 server_guild_id
               elsif group.present?
                 group.server.guild_id
               else
                 ENV['DISCORD_GUILD_ID']
               end
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
