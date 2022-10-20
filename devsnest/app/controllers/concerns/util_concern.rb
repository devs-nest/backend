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
      g.paper_trail_event = 'assign_batch_leader'
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
      coins: user.coins,
      server_details: server_details,
      batch_leader_details: Group.where(batch_leader_id: user.id)&.pluck(:name),
      batch_eligible: user.web_active && user.discord_active && user.accepted_in_course,
      verified: user.web_active && user.discord_active,
      group_name: group.present? ? group&.name : nil,
      group_server_link: group.present? ? group&.server&.link : nil,
      waitlisted: user.is_fullstack_course_22_form_filled == true && user.accepted_in_course == false
    }
  end

  def send_group_change_message(user, group)
    group_name = group.name
    puts("Sending group change message to #{user.discord_id}")
    link = group&.server&.link
    ping_discord(user, 'Group_Join', [group_name, link])
    ping_discord(group, 'User_Joined', ["#{user.name}|#|#{user.discord_id}"])
    template_id = EmailTemplate.find_by(name: 'group_join_message')&.template_id
    EmailSenderWorker.perform_async(user.email, {
                                      'unsubscribe_token': user.unsubscribe_token,
                                      'username': user.username,
                                      'group_name': group_name,
                                      'server_link': link
                                    }, template_id)
  end

  def ping_discord(model, message_type, params = [])
    case model.class.name
    when 'User'
      message = get_user_message_string(model, message_type, params)
      UserNotifierWorker.perform_async(model.discord_id, message) if model.discord_active || !message.nil?
    when 'Group'
      message = get_group_message_string(model, message_type, params)
      GroupNotifierWorker.perform_async([model.name], message, model.server&.guild_id) unless message.nil?
    end
  end

  def get_user_message_string(user, message_type, params)
    case message_type
    when 'Group_Join'
      # TODO: Add safe operator
      "Congrats  #{user.username}, You have joined the group #{params[0]},\nPlease join this server, if you haven't already\n#{params[1]}\nOnce you join this server, you will automatically be able to talk to your group and meet them in a voice call"
    end
  end

  def get_group_message_string(group, message_type, params)
    case message_type
    when 'Instructions' # Instuctions on Group
      "\nHey, Guys!\n

    I hope you're having a great time so far.\n\n

    We've been really excited about our peer learning program, and we wanted to make sure you were aware of all the ways you can get involved.\n\n

    Here are some instruction you have to follow:\n\n

    1. Deciding a Vice team leader,\n        - A vice team leader (VTL) will work as Team Leader when team leader is not available.\n\n
    2. Scrum time,\n        - Chose a time slot which is convenience for all the team members to do Scrums calls."
    when 'Commands' # Useful commands
      "\nHey, Guys!!\n\n

    I hope you're having a great time in our group. Here are some of the commands you can use:\n\n

    Command - command description \n
    .info - In bug-reports or in your team channel will show your data and reassign your roles."
    when 'Ping_Scrum_Time' # Reminder to ping  Scrum Time
      "\nHello , Guys!!,\nHey guys, it's your time to join in the scrum in #{params[0]} minutes. 👋🏻\n Let's get our bits together and get ready to learn. "
    when 'Class_Start'
      "\nHello, Guys!!,\nToday's class is about to start in 15 minutes, \nTime : 8:30 PM           Where:  https://youtube.com/c/devsnest"
    when 'Ping_Attendance' # Ping attendance
      data = Scrum.where(group_id: group.id, creation_date: Date.today, attendance: true).pluck(:user_id)
      if data.length.positive?
        message = "Hello, Guys!!,\n\nToday's attendance sheet is here,\n\n "
        data.each do |user_id|
          user = User.find_by(id: user_id)
          message += "#{user.username} \n"
        end
      else
        "\nHello, Guys!!,\nNo one attended today's scrum."
      end
    when 'Report_Weekly_Scrum' # Report about weekly scrum
      data = group.weekly_data
      total_scrums = data[0][:total_scrums] || 0
      message = "\nHey guys! Hope you're having a great week so far.\n

    We wanted to give you guys a quick update of last week,\n
    Total Scrums happened: #{total_scrums || 0} \n"
      if total_scrums.positive?
        message += "Leaderboard:- \n"
        data.sort_by(&:scrum_attended_count).each do |d|
          message += "Name:- #{d[:user_name]} =>> THA Solved #{data[:solved_assignments_count]}\n"
        end
      end
      message
    when 'User_Joined' # User joined the group
      "\nHello, Guys!!,\nWelcome new teammate! #{params[0]}\nLet's build a stronger team together.\n\nHappy Coding!"
    when 'Initialize_Group_Scrum' # Initialize Group Scrum
      "\nHello, Guys!!,\n
    Hope you are enjoying the Server! \n
    You can connect with your group here, We encourage you to meet tomorrow for your first meeting and get to know each other at 7pm\n
    The agenda of the meeting will be \n\n
    1. Get to know each other\n
    2 To decide a daily catchup time that works for you all\n
    3. Choose your goals for the course\n
    4. Talk to your team and  team leader and see how all you can manage responsibilities together\n
    5. Nominate yourself if you want to become Vice team leader, and let the team leader ping in the admins"
    end
  end
end
