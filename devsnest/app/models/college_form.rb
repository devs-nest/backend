# frozen_string_literal: true

# == Schema Information
#
# Table name: college_forms
#
#  id                  :bigint           not null, primary key
#  college_name        :string(255)
#  email               :string(255)
#  faculty_position    :string(255)
#  phone_number        :string(255)
#  tpo_or_faculty_name :string(255)      not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#
class CollegeForm < ApplicationRecord
  validates_uniqueness_of :user_id
end
