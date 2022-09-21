# frozen_string_literal: true

class JobSkillMapping < ApplicationRecord
  belongs_to :job
  belongs_to :skill
end
