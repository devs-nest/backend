# frozen_string_literal: true

# worker that appends tokens to a message
class GroupModifierWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 2
  def perform(action, group_name, server_guild_id = nil)
    guild_id = group_guild_id(group_name[0], server_guild_id)
    data = {
      guild_id: guild_id,
      action: action,
      group_name: group_name
    }
    AwsSqsWorker.perform_async('group_modifier', data)
  end
end
