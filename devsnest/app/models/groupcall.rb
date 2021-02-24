# frozen_string_literal: true

class Groupcall < ApplicationRecord
  enum choice: %i[no yes]
  has_one :user

  def self.add_meeting(user_id, choice)
    week = Date.current.cweek
    year = Date.current.year
    meeting = Groupcall.find_or_create_by(user_id: user_id, week: week, year: year)
    meeting.choice = choice
    meeting.save
    meeting
  end

  def self.fetch_groups
    week = Date.current.cweek
    year = Date.current.year

    count = -1
    groups = []
    cur_group = []

    group_no = 1

    Groupcall.where(choice: 'yes', week: week, year: year).each do |gc|
      gc.update(group_id: group_no)
      count += 1
      count = count % 4
      if count.zero? && (cur_group != [])
        groups.append(cur_group)
        cur_group = []
        group_no += 1
      end
      discord_id = User.find_by(id: gc.user_id).discord_id
      cur_group.append({ user_id: gc.user_id, discord_id: discord_id })
    end
    groups.append(cur_group)
    groups
  end
end
