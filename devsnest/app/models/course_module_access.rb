# frozen_string_literal: true

# access management for bootcamp
class CourseModuleAccess < ApplicationRecord
  belongs_to :accessor, polymorphic: true
  belongs_to :course_module

  enum status: %i[requested payment_pending granted]
end
