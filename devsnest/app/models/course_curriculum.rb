# frozen_string_literal: true

# == Schema Information
#
# Table name: course_curriculums
#
#  id          :bigint           not null, primary key
#  course_type :integer
#  day         :integer
#  locked      :boolean          default(TRUE)
#  resources   :json
#  topic       :string(255)
#  video_link  :text(65535)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :integer
#
# Indexes
#
#  index_course_curriculums_on_course_id_and_course_type  (course_id,course_type)
#  index_course_curriculums_on_course_id_and_day          (course_id,day)
#
class CourseCurriculum < ApplicationRecord
  belongs_to :course
  enum course_type: %i[dsa frontend backend]
  has_many :assignment_questions
end
