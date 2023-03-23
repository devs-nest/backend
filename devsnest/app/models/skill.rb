# frozen_string_literal: true

# == Schema Information
#
# Table name: skills
#
#  id         :bigint           not null, primary key
#  logo       :text(16777215)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Skill < ApplicationRecord
  has_many :job_skill_mappings
  has_many :jobs, through: :job_skill_mappings

  has_many :user_skills
  has_many :user, through: :user_skills

  after_commit :expire_cache
end
