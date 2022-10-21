# frozen_string_literal: true

# == Schema Information
#
# Table name: job_skill_mappings
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  job_id     :bigint           not null
#  skill_id   :bigint           not null
#
# Indexes
#
#  index_job_skill_mappings_on_job_id               (job_id)
#  index_job_skill_mappings_on_job_id_and_skill_id  (job_id,skill_id) UNIQUE
#  index_job_skill_mappings_on_skill_id             (skill_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (skill_id => skills.id)
#
class JobSkillMapping < ApplicationRecord
  belongs_to :job
  belongs_to :skill
end
