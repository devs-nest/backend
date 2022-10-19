# frozen_string_literal: true

# == Schema Information
#
# Table name: assignment_questions
#
#  id                   :bigint           not null, primary key
#  question_type        :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  course_curriculum_id :integer
#  question_id          :integer
#
class AssignmentQuestion < ApplicationRecord
  belongs_to :question, polymorphic: true
  belongs_to :course_curriculum
end
