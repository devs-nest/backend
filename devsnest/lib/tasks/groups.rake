# frozen_string_literal: true

namespace :add_groups do
  require 'csv'
  task data: :environment do
    Group.destroy_all
    GroupMember.destroy_all
    filename = File.join Rails.root, 'scripts/group_formation.csv'
    errors = []
    CSV.foreach(filename, headers: true) do |row|
      name = row[1]
      group = if name.present?
                Group.create(name: name)
              else
                Group.last
              end
      if row[2].present?
        user = User.find_by(discord_id: row[2])

        unless user.present?
          errors << [row[2], group.name]
          puts '*' * 80
          puts "#{row[2]}, #{group.name}"
          puts '*' * 80
          next
        end

        GroupMember.create(user_id: user.id, group_id: group.id)
        owner = User.find_by(discord_id: row[7])
        unless owner.present?
          errors << [row[7], group.name, 'owner']
          puts '*' * 80
          puts "#{row[7]}, #{group.name}"
          puts '*' * 80
          next
        end
        group.owner_id = owner.id
        group.save
      end
    end
    puts 'Printing Errors'
    puts '*' * 80
    puts errors
    puts '*' * 80
  end
end
