# frozen_string_literal: true

namespace :remove_duplicate_username do
  desc 'Remove duplicate username'
  require 'csv'
  task remove_duplicate_username: :environment do
    start = 1
    filename = File.join Rails.root, 'scripts/Duplicate_usernames.csv'
    CSV.foreach(filename, headers: true) do |row|
      users = User.where(username: row['username'])
      if users.present?
        users.all.each do |user|
          user.update!(username: start.to_s)
          start += 1
        end
      else
        puts row['username']
      end
    end
  end
end
