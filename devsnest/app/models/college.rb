# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id          :bigint           not null, primary key
#  is_verified :boolean          default(FALSE)
#  name        :string(255)
#
class College < ApplicationRecord
  has_many :college_profiles
  has_many :college_invites
  has_many :college_structure

  def self.create_college(college_name)
    College.create(name: college_name)
  end

  def self.domains_matched?(email1, email2)
    email1.split('@')[-1] == email2.split('@')[-1]
  end

  def students_active_in_last_month
    college_profiles = CollegeProfile.includes(:user).where(college_id: id)
    user_ids = college_profiles.map(&:user_id).compact
    dsa_solved = UserChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    
  end

  def students_completed_any_bootcamp
    college_profiles = CollegeProfile.includes(:user).where(college_id: id)
    user_ids = college_profiles.map(&:user_id).compact
    dsa_solved = UserChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    total_dsa_questions = Challenge.where(is_active: true).count

    fe_solved = FrontendChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    total_fe_questions = 0
  end

  def activity
    Rails.cache.fetch("college_activity_#{id}", expires_in: 6.hours) do
      {
        name: name,
        dsa_solved: Challenge.count_solved(id),
        dsa_solved_by_difficulty: Challenge.split_by_difficulty,
        fe_solved: FrontendChallenge.count_solved(id),
        fe_solved_by_topic: FrontendChallenge.split_by_topic,
        tha_details: tha_details, # Bootcamp Progress
        leaderboard_details: leaderboard_details('dsa'),
        fe_leaderboard_details: leaderboard_details('frontend')
      }
    end
  end
end
