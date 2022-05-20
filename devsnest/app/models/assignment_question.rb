# frozen_string_literal: true

class AssignmentQuestion < ApplicationRecord
  belongs_to :question, polymorphic: true
  belongs_to :course_curriculum
end
