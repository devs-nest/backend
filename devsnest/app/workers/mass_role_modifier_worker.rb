# frozen_string_literal: true

# worker that appends tokens to a message
class MassRoleModifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 2
  def perform(action, discord_ids, role_name)
    discord_ids.each_slice(20) do |ids|
      data = {
        action: action,
        discord_ids: ids,
        role_name: role_name
      }
      AwsSqsWorker.perform_async('role_modifier', data)
    end
  end
end
