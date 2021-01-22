# frozen_string_literal: true

class User < ApplicationRecord
  has_one :mmt
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable,
         jwt_revocation_strategy: JwtBlacklist
  serialize :role, Array
  after_create :assign_mentor
  after_initialize :set_defaults

  def assign_mentor
    mentorList = [9, 10, 11]
    id = self.id
    index = id % mentorList.length
    mmt = Mmt.new(user_id: id, mentor_id: mentorList[index])
    mmt.save
    @user = User.find_by(id: mentorList[index])
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

  def self.get_scorecard
    # change it to actual scorecard
    User.pluck(:id).sort
  end

  def self.update_percent(user_id)
    user = User.find(user_id)
    count_of_completed_task = Submission.where(status: :done, user_id: user_id).count
    count_of_total_question = Content.where(data_type: 0).count
    User.where(id: user_id).update(percent_complete: Counter.calculate_percent_complete(count_of_completed_task, count_of_total_question))
  end

  def set_defaults
    self.percent_complete ||= 0.0
    self.score ||= 0
  end

end
