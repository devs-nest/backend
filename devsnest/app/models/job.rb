# frozen_string_literal: true

class Job < ApplicationRecord
  has_many :job_applications
  has_many :job_skill_mappings
  has_many :skills, through: :job_skill_mappings
  has_one :organization

  enum job_type: %i[remote onsite]
  enum job_category: %i[full_time part_time contract internship]
end
