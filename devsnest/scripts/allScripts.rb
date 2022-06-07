#  Mass Notifier Example
MassNotifierWorker.perform_async(users,'Hello World!')

#  Role Modifier Example
discord_id=User.first.discord_id
RoleModifierWorker.perform_async('add_role', 706820473195069490, 'Devsnest People')
RoleModifierWorker.perform_async('delete_role', discord_id, 'Role Name')



#  Mass Role Modifier Example
discord_ids  = User.where(user_type:1).pluck(:discord_id) # get all admin discord ids
discord_ids  = User.where(discord_active:true,accepted_in_course:true).pluck(:discord_id) # get all DN JUNE BATCH PEOPLE

MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, 'DN JUNE BATCH')
MassRoleModifierWorker.perform_async('add_mass_role', discord_ids.slice(0,10), 'Verified')
MassRoleModifierWorker.perform_async('delete_mass_role', discord_ids, 'TEAM NAME')

#  Group Modifier Example
GroupModifierWorker.perform_async('create', ['V2 ADHIKRAM TEAM'])
GroupModifierWorker.perform_async('destroy', [group.name])

GroupNotifierWorker.perform_async('V2 Alpha Tester Team', "Hello PEEPS")

#  Mass group Modifier Example
Group.v2.where(name:'V2 Sirius TEAM').each do |group|
    discord_ids=[]
    puts("-----------------------------------------------------")
    puts(group.name)
    group.group_members.each do |member|
        user=User.find_by(id:member.user_id)
        puts("-------------#{user.name}")
        discord_ids.push(user.discord_id)
    end
    MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, group.name)
end

Group.v2.each do |u|
    u.update(members_count:u.group_members.count)
    # puts("#{u.name} has #{u.group_members.count} members and #{u.members_count} members_count") if u.group_members.count != u.members_count
end
#Check all bots
id = User.find_by(name:'Adhikram').discord_id

NotificationBot.all.each do |bot|
    puts(bot.bot_username)
    data = {bot_id: bot.id, message: bot.bot_username,discord_id: [id]}
    AwsSqsWorker.perform_async('notification', data)
end

# Wrong Mail Format Finder
User.where(discord_active:false,web_active:false).each do |u|
      name=u.email.split('@')[0]
      names.push(u.email) if u.email.count("@")>0 and name.count("a-zA-Z")>0
    end
names.each do |u|
    User.find_by(email:u).update(web_active:true)
    end
