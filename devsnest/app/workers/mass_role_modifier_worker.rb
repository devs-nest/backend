# frozen_string_literal: true

# worker that appends tokens to a message
class MassRoleModifierWorker
  include Sidekiq::Worker

  def perform(action, discord_ids, role_name)
    start = 0
    bucket_size = 50
    while start * bucket_size <= discord_ids.length
      discord_id = discord_ids.slice(start * bucket_size, bucket_size)

      data = {
        action: action,
        discord_ids: discord_id,
        role_name: role_name
      }
      AwsSqsWorker.perform_async('role_modifier', data)
      start += 1
    end
  end
end
