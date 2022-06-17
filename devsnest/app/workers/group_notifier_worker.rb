# frozen_string_literal: true

# worker that appends tokens to a message
class GroupNotifierWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 5
  def perform(group_name, message, guild_id = ENV['DISCORD_GUILD_ID'])
    data = {
      guild_id: guild_id,
      group_name: group_name[0],
      message: message
    }
    AwsSqsWorker.perform_async('group_notifier', data)
  end
end
