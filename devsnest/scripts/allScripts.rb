#  Mass Notifier Example
MassNotifierWorker.perform_async(users,'Hello World!')

#  Role Modifier Example
discord_id=User.first.discord_id
RoleModifierWorker.perform_async('add_role', 706820473195069490, 'DN JUNE BATCH')
RoleModifierWorker.perform_async('delete_role', discord_id, 'Role Name')



#  Mass Role Modifier Example
discord_ids  = User.where(user_type:1).pluck(:discord_id) # get all admin discord ids
discord_ids  = User.where(discord_active:true,accepted_in_course:true).pluck(:discord_id) # get all DN JUNE BATCH PEOPLE

MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, 'Devsnest People')
MassRoleModifierWorker.perform_async('add_mass_role', discord_ids.slice(0,10), 'Verified')
MassRoleModifierWorker.perform_async('delete_mass_role', discord_ids, 'TEAM NAME')

#  Group Modifier Example
GroupModifierWorker.perform_async('create', ['V2 PHENOMENAL  CULTS Team'])
GroupModifierWorker.perform_async('destroy', [group.name])

GroupNotifierWorker.perform_async('V2 Alpha Tester Team', "Hello PEEPS")

#  Mass group Modifier Example
Group.v2.where(server_id:).each do |group|
    GroupModifierWorker.perform_async('create', [group.name],group.server.guild_id)
    discord_ids=[]
    puts("-----------------------------------------------------")
    puts(group.name)
    group.group_members.each do |member|
        user=User.find_by(id:member.user_id)
        puts("-------------#{user.name}")
        discord_ids.push(user.discord_id)
    end
    MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, group.name,group.server.guild_id)
end
if u.group_members.count==0
    puts(u.name)
end
u.update(members_count:u.group_members.count)
Group.v2.each do |u|
    if Group.where(slug:u.slug).count > 1
        puts(Group.where(slug:u.slug).pluck(:name))
        puts("------------------------------------------------------------------")
    end
end
puts("#{u.name} has #{u.group_members.count} members and #{u.members_count} members_count") if u.group_members.count != u.members_count
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

discord_id=[]
Group.v2.all.each do |g|
    g.group_members.each do |m|
        discord_id.push(User.find_by(id:m.user_id).discord_id)
    end
end
GroupMember.find_by(user_id:User.find_by(discord_id:793481584970825778).id).group.name

# Server.create(name: 'Devsnest Main', guild_id: '781576398414413854', link: 'https://discord.gg/ZqXBanhE')
# Server.create(name: 'Devsnest Community 2.0', guild_id: '985833665940578304', link: 'https://discord.gg/rwSfztZf')