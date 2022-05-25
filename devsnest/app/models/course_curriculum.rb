# frozen_string_literal: true

# Course Curriculum Model
class CourseCurriculum < ApplicationRecord
  belongs_to :course
  enum course_type: %i[dsa frontend backend]
  serialize :resources, Array
  has_many :assignment_questions
end
