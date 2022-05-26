# frozen_string_literal: true

# worker that appends tokens to a message
class GroupNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(action, group_name, message)
    data = {
      action: action,
      group_name: group_name,
      message: message
    }
    AwsSqsWorker.perform_async('role_modifier', data)
  end
end
