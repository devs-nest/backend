#  Mass Notifier Example
MassNotifierWorker.perform_async('Hello World!')

#  Role Modifier Example
discord_id=User.first.discord_id
RoleModifierWorker.perform_async('add_role', discord_id, 'Role Name')
RoleModifierWorker.perform_async('delete_role', discord_id, 'Role Name')



#  Mass Role Modifier Example
discord_ids  = User.where(user_type:1).pluck(:discord_id) # get all admin discord ids
discord_ids  = User.where(discord_active:true,accepted_in_course:true).pluck(:discord_id) # get all DN JUNE BATCH PEOPLE

MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, 'DN JUNE BATCH')
MassRoleModifierWorker.perform_async('delete_mass_role', discord_ids, 'TEAM NAME')

#  Group Modifier Example
GroupModifierWorker.perform_async('create', group.name)
GroupModifierWorker.perform_async('destroy', group.name)


#  Mass group Modifier Example
Group.where(version:2).each do |group|
    discord_ids=[]
    GroupModifierWorker.perform_async('create', group.name)
    puts("-----------------------------------------------------")
    puts(group.name)
    group.group_members.each do |member|
        user=User.find_by(id:member.user_id)
        puts("-------------#{user.name}")
        discord_ids.push(user.discord_id)
    end
    MassRoleModifierWorker.perform_async('add_mass_role', discord_ids, 'DN JUNE BATCH')
end


#Check all bots
id = User.find_by(name:'Adhikram').discord_id

NotificationBot.all.each do |bot|
    puts(bot.name)
    data = {bot_id: bot.id, message: {bot.id},discord_id: [id]}
    AwsSqsWorker.perform_async('notification', data)
end