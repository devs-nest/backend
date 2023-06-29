# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id             :bigint           not null, primary key
#  archived       :boolean          default(TRUE)
#  completed      :boolean          default(FALSE)
#  current_module :string(255)
#  name           :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_courses_on_name  (name)
#
class Course < ApplicationRecord
  has_many :course_curriculums, dependent: :delete_all
end
