# frozen_string_literal: true

# worker that appends tokens to a message
class GroupMemberNotifierWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5
  def perform(group_name, event_message)
    Group.find_by(name: group_name).group_members.each do |member|
      user = User.find_by(id: member.user_id)
      data = {
        bot_id: user.bot_id, message: event_message,
        discord_id: [user.discord_id]
      }
      AwsSqsWorker.perform_async('notification', data, ENV['SQS_NOTIFIER_URL'])
    end
  end
end
