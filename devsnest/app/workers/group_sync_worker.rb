# frozen_string_literal: true

# worker that syncs groups with discord
class GroupSyncWorker
  include Sidekiq::Worker
  include UtilConcern
  sidekiq_options retry: 5
  def perform(group_name = '', server_id = '')
    if group_name.!empty?
    # If group name given then sync group
      Group.find_by(name: group_name).group_members.each do |member|
        server_user = ServerUser.find_by(user_id: member.user_id, server_id: member.group.server_id)
        # Not using safe operation because group member will always have the correct values
        unless server_user.present?
          user = User.find_by(id: member.user_id)
          send_group_change_message(user.id, member.group.name)
        end
      end
    elsif server_id.!empty?
    # If server_id present then sync server
      Group.where(server_id: server_id).each do |group|
        Group.find_by(name: group.name).group_members.each do |member|
          server_user = ServerUser.find_by(user_id: member.user_id, server_id: member.group.server_id)
          unless server_user.present?
            user = User.find_by(id: member.user_id)
            send_group_change_message(user.id, member.group.name)
          end
        end
      end

    else
      puts('Provide Server ID or Group Name')
    end
  end
end
