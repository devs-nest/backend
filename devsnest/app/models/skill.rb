# frozen_string_literal: true

class Skill < ApplicationRecord
  has_many :job_skill_mappings
  has_many :jobs, through: :job_skill_mappings
  after_commit :expire_cache
end
