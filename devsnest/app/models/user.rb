# frozen_string_literal: true

class User < ApplicationRecord
  has_one :mmt
  devise :database_authenticatable,
         :jwt_authenticatable,
         :registerable, :omniauthable,
         jwt_revocation_strategy: JwtBlacklist
  serialize :role, Array
  after_create :assign_mentor

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

  def self.get_scorecard
    # change it to actual scorecard
    User.pluck(:id).sort
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"],:uid => access_token.uid).first
    # Uncomment the section below if you want users to be created if they don't exist
    unless user
        user = User.create(name: data["name"],
           email: data["email"],
           uid: access_token.uid,
           provider: access_token.provider,
           password: Devise.friendly_token[0,20]
        )
    end
    user
end
end
