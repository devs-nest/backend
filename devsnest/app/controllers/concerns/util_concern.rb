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

  def send_group_change_message(user_id, group_name)
    user = User.find_by(id: user_id)
    puts("Sending group change message to #{user.discord_id}")
    server = Group.find_by(name: group_name).server
    link = server.link
    message = "Congrats  #{user.username}, You have joined the group #{group_name},\nPlease join this server, if you haven't already\n#{link}\nOnce you join this server, you will automatically be able to talk to your group and meet them in a voice call"
    UserNotifierWorker.perform_async(user.discord_id, message)
    template_id = EmailTemplate.find_by(name: 'group_join_message')&.template_id
    EmailSenderWorker.perform_async(user.email, {
                                      'unsubscribe_token': user.unsubscribe_token,
                                      'username': user.username,
                                      'group_name': group_name,
                                      'server_link': link
                                    }, template_id)
  end
end
