# frozen_string_literal: true

# == Schema Information
#
# Table name: courses
#
#  id             :bigint           not null, primary key
#  archived       :boolean          default(TRUE)
#  current_module :string(255)
#  name           :string(255)
#  visibility     :integer          default("private_course"), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_courses_on_name  (name)
#
class Course < ApplicationRecord
  has_many :course_modules, dependent: :delete_all
  has_many :course_curriculums, dependent: :delete_all

  enum visibility: %i[private_course public_course]
end
