# frozen_string_literal: true

# utils module
module UtilConcern
  extend ActiveSupport::Concern
  def group_guild_id(role_name, server_guild_id)
    group = Group.find_by(name: role_name)
    if server_guild_id.present?
      server_guild_id
    elsif group.present?
      group.server.guild_id
    end
  end

  def user_group(discord_id)
    user = User.find_by(discord_id: discord_id)
    if user.present?
      groupmember = GroupMember.find_by(user_id: user.id)
      return 'No group found' if groupmember.nil?

      groupmember.group
    else
      'No user found'
    end
  end

  def send_group_change_message(discord_id, group_name)
    puts("Sending group change message to #{discord_id}")
    server = Group.find_by(name: group_name).server
    message = "You have been added to the group #{group_name} on #{server.name} /n Join the group here: #{server.link}"
    MassNotifierWorker.perform_async([discord_id], message)
  end
end
