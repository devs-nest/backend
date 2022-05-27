# frozen_string_literal: true

# worker that appends tokens to a message
class GroupNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(group_name, message)
    data = {
      group_name: group_name,
      message: message
    }
    AwsSqsWorker.perform_async('group_notifier', data)
  end
end
