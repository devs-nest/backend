# == Schema Information
#
# Table name: bootcamp_progresses
#
#  id                   :bigint           not null, primary key
#  completed            :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  course_id            :integer
#  user_id              :integer
#
# Indexes
#
#  index_bootcamp_progresses_on_user_id  (user_id)
#
class BootcampProgress < ApplicationRecord
  belongs_to :user
  belongs_to :course
  belongs_to :course_curriculum
  validates_uniqueness_of :user_id, scope: %i[course_id course_curriculum_id]
end
