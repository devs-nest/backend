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


  def self.activity(id)
    data = {}
    college_profiles = CollegeProfile.where(college_id: id, authority_level: 'student')
    user_ids = college_profiles.map(&:user_id).compact.uniq

    dsa_solved = UserChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    total_dsa_questions = Challenge.where(is_active: true).count

    fe_solved = FrontendChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    total_fe_questions = FrontendChallenge.where(is_active: true).count

    be_solved = BackendChallengeScore.where(user_id: user_ids).where('created_at >= ?', Time.zone.now - 1.month).group(:user_id).count
    total_be_questions = BackendChallenge.where(is_active: true).count

    students_active_in_last_month = (user_ids & [dsa_solved.keys, fe_solved.keys, be_solved.keys].flatten).count

    students_completed_dsa_bootcamp = []
    students_completed_fe_bootcamp = []
    students_completed_be_bootcamp = []
    college_profiles.each do |college_profile|
      user_id = college_profile.user_id
      user_dsa_solved = dsa_solved[user_id]

      if user_dsa_solved >= (total_dsa_questions * 70/100)
        students_completed_dsa_bootcamp >> college_profile.id
      end

      user_fe_solved = fe_solved[user_id]
      if user_fe_solved >= (total_fe_questions * 70/100)
        students_completed_fe_bootcamp >> college_profile.id
      end

      user_be_solved = be_solved[user_id]
      if user_be_solved >= (total_be_questions * 70/100)
        students_completed_be_bootcamp >> college_profile.id
      end
    end
    
    { 
      students_active_in_last_month: students_active_in_last_month, 
      students_completed_dsa_bootcamp: students_completed_dsa_bootcamp,
      students_completed_fe_bootcamp: students_completed_fe_bootcamp,
      students_completed_be_bootcamp: students_completed_be_bootcamp
    }
  end

  def activity
    Rails.cache.fetch("college_activity_#{id}", expires_in: 6.hours) do
      College.activity(id)
    end
  end
end
