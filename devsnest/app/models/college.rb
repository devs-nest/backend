# frozen_string_literal: true

# == Schema Information
#
# Table name: colleges
#
#  id          :bigint           not null, primary key
#  is_verified :boolean          default(FALSE)
#  name        :string(255)
#  slug        :string(255)
#
class College < ApplicationRecord
  has_many :college_profiles
  has_many :college_invites
  has_many :college_structure
  has_many :college_branches

  has_many :course_module_accesses, as: :accessor
  has_many :course_modules, through: :course_module_accesses
  before_save { self.slug = name.parameterize }

  validates :slug, uniqueness: true, allow_nil: true

  def self.create_college(college_name)
    College.create(name: college_name)
  end

  def self.domains_matched?(email1, email2)
    email1.split('@')[-1] == email2.split('@')[-1]
  end

  def self.activity(id)
    college = College.find_by_id(id)
    college_profiles = CollegeProfile.where(college_id: id, authority_level: 'student')
    user_ids = college_profiles.pluck(:user_id).compact.uniq
    active_students = []
    students_completed_modules_till_last_month = {}
    students_completed_modules_till_now = {}
    top_performing_batches = {}
    college.course_modules.each do |course_module|
      active_students << course_module.students_active_in_last_month(user_ids)
      students_completed_modules_till_last_month.merge!(course_module.activity(college_profiles.ids, Time.zone.now - 1.month, top_performing_batches))
      students_completed_modules_till_now.merge!(course_module.activity(college_profiles.ids, Time.zone.now, top_performing_batches))
    end
    students_active_in_last_month = (user_ids & active_students.compact.uniq).count
    top_performing_batches = top_performing_batches.sort_by { |_key, value| -value.values.sum }.first(3).to_h
    {
      total_students: user_ids.count,
      students_active_in_last_month: students_active_in_last_month,
      students_completed_modules_till_last_month: students_completed_modules_till_last_month,
      students_completed_modules_till_now: students_completed_modules_till_now,
      top_performing_batches: top_performing_batches
    }
  end

  def activity
    Rails.cache.fetch("college_activity_#{id}", expires_in: 1.day) do
      College.activity(id)
    end
  end
end
