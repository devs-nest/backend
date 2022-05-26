# frozen_string_literal: true

# Course Curriculum Model
class CourseCurriculum < ApplicationRecord
  belongs_to :course
  enum course_type: %i[dsa frontend backend]
  has_many :assignment_questions
end
