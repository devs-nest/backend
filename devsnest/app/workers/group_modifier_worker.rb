# frozen_string_literal: true

# worker that appends tokens to a message
class GroupModifierWorker
  include Sidekiq::Worker

  def perform(action, group_name)
    data = {
      action: action,
      group_name: group_name
    }
    AwsSqsWorker.perform_async('group_modifier', data)
  end

  def perform(_action, old_group_name, new_group_name)
    data = {
      action: 'update',
      new_group_name: new_group_name,
      old_group_name: old_group_name
    }
    AwsSqsWorker.perform_async('group_modifier', data)
  end
end
