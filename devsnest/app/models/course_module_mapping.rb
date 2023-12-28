# frozen_string_literal: true

# Course Module Mapping Model
class CourseModuleMapping < ApplicationRecord
  belongs_to :course
  belongs_to :course_module
end
