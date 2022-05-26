# frozen_string_literal: true

# Course Model
class Course < ApplicationRecord
  has_many :course_curriculums, dependent: :delete_all
end
