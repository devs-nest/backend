# == Schema Information
#
# Table name: user_skills
#
#  id         :bigint           not null, primary key
#  level      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  skill_id   :integer
#  user_id    :integer
#
class UserSkill < ApplicationRecord
  belongs_to :user
  belongs_to :skill

  enum level: %i[novice intermediate expert]
end
