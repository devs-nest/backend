# frozen_string_literal: true

# worker that appends tokens to a message
class RoleModifierWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 5
  def perform(action, discord_id, role_name, guild_id = ENV['DISCORD_GUILD_ID'])
    data = {
      guild_id: guild_id,
      action: action,
      discord_id: discord_id,
      role_name: role_name
    }
    AwsSqsWorker.perform_async('role_modifier', data)
  end
end
