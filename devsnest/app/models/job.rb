# frozen_string_literal: true

# == Schema Information
#
# Table name: jobs
#
#  id              :bigint           not null, primary key
#  additional      :json
#  archived        :boolean          default(FALSE)
#  description     :text(65535)
#  experience      :string(255)
#  job_category    :integer
#  job_type        :integer
#  location        :string(255)
#  salary          :string(255)
#  slug            :string(255)
#  title           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :integer
#  user_id         :integer
#
# Indexes
#
#  index_jobs_on_organization_id  (organization_id)
#  index_jobs_on_slug             (slug) UNIQUE
#
class Job < ApplicationRecord
  has_many :job_applications
  has_many :job_skill_mappings
  has_many :skills, through: :job_skill_mappings, dependent: :destroy
  belongs_to :organization

  enum job_type: %i[remote onsite]
  enum job_category: %i[full_time part_time contract internship]
end
