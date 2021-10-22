# frozen_string_literal: true

namespace :remove_duplicate_username do
  desc 'Remove duplicate username'
  require 'csv'
  task remove_duplicate_username: :environment do
    filename = File.join Rails.root, 'scripts/Duplicate_usernames.csv'
    CSV.foreach(filename, headers: true) do |row|
      username = row['username']
      users = User.where(username: username)
      if users.present?
        start = 1
        users.all.each do |user|
          user.update!(username: "#{username}#{start}")
          start += 1
        end
      else
        puts username
      end
    end
  end
end
