# frozen_string_literal: true

class User < ApplicationRecord
  has_one :mmt
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtBlacklist
  serialize :role, Array

  def assign_mentor
    mentor_list = [8, 9, 10]
    id = self.id
    index = id % mentor_list.length
    mmt = Mmt.new(user_id: id, mentor_id: mentor_list[index])

    mmt.save
    @user = User.find_by(id: mentor_list[index])
    mentor_name = @user.name
  end

  def self.assign_mentor_all
    scorecard = User.get_scorecard
    count = scorecard.count
    # add logic for first 2 people
    2.upto(count - 1).each do |i|
      user_id = scorecard[i]
      mentor_id = scorecard[i - 2]
      mmt = Mmt.find_by(user_id: user_id)
      if mmt
        mmt.mentor_id = mentor_id
      else
        mmt = Mmt.new(user_id: user_id, mentor_id: mentor_id)
      end
      mmt.save
    end
  end

    index = id%mentorList.length()
    mmt = Mmt.new(user_id: id, mentor_id: mentorList[index])
    mmt.save
    @user = User.find_by(id:mentorList[index])
    mentor_name = @user.name

  end

  def self.assign_mentor_all
    scorecard = User.get_scorecard
    count = scorecard.count
    # add logic for first 2 people
    2.upto(count-1).each do |i|
      user_id = scorecard[i]
      mentor_id = scorecard[i-2]
      mmt = Mmt.find_by(user_id: user_id)
      if mmt
         mmt.mentor_id = mentor_id
      else
        mmt = Mmt.new(user_id: user_id, mentor_id: mentor_id)
      end
      mmt.save
    end
  end

  def self.get_scorecard
    # change it to actual scorecard
    User.pluck(:id).sort
  end
end
