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

  def assign_role_to_batchleader(user, groups)
    groups.each do |g|
      old_batch_leader = User.find_by(id: g.batch_leader_id)
      RoleModifierWorker.perform_async('add_role', user.discord_id, 'Batch Leader', g.server&.guild_id)
      RoleModifierWorker.perform_async('add_role', user.discord_id, g.name, g.server&.guild_id)
      RoleModifierWorker.perform_async('delete_role', old_batch_leader.discord_id, g.name, g.server&.guild_id) if old_batch_leader.present?
      g.update(batch_leader_id: user.id)
    end
  end

  def get_user_details(user)
    server_details = Server.where(id: ServerUser.where(user_id: user.id)&.pluck(:server_id))&.pluck(:name)
    group = GroupMember.find_by(user_id: user.id)&.group
    {
      id: user.id,
      name: user.name,
      discord_id: user.discord_id,
      email: user.web_active ? user.email : nil,
      mergeable: user.discord_active && user.web_active,
      server_details: server_details,
      batch_leader_details: Group.where(batch_leader_id: user.id)&.pluck(:name),
      batch_eligible: user.web_active && user.discord_active && user.accepted_in_course,
      verified: user.web_active && user.discord_active,
      group_name: group.present? ? group&.name : nil,
      group_server_link: group.present? ? group&.server&.link : nil
    }
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
