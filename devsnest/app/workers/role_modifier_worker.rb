# frozen_string_literal: true

# worker that appends tokens to a message
class RoleModifierWorker
  include Sidekiq::Worker

  def perform(action, discord_id, _role_name)
    data = {
      action: action,
      discord_id: discord_id,
      group_name: group_name
    }
    AwsSqsWorker.perform_async('role_modifier', data)
  end
end
