# frozen_string_literal: true

namespace :batch_leader do
    desc 'Assign Batch Leader to groups'
    require 'csv'
    task data: :environment do
      filename = File.join Rails.root, 'scripts/BatchLeader.csv'
      CSV.foreach(filename, headers: true) do |row|
        user_id = User.find_by(discord_id: row[0])
        row[1].split(',').each do |name|
            group = Group.find_by(name: name)
            group.update(batch_leader_id: user_id)
        end
      end
    end
  end
  