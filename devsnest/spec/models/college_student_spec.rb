# == Schema Information
#
# Table name: college_students
#
#  id                            :bigint           not null, primary key
#  diploma_passing_year          :string(255)
#  diploma_result                :integer
#  diploma_university_name       :string(255)
#  dob                           :date
#  ed_detail                     :boolean          default(FALSE)
#  email                         :string(255)
#  high_school_board             :string(255)
#  high_school_name              :string(255)
#  high_school_passing_year      :string(255)
#  high_school_result            :integer
#  higher_education_type         :integer
#  higher_secondary_board        :string(255)
#  higher_secondary_passing_year :string(255)
#  higher_secondary_result       :integer
#  higher_secondary_school_name  :string(255)
#  name                          :string(255)
#  parent_email                  :string(255)
#  parent_name                   :string(255)
#  parent_phone                  :string(255)
#  pd_detail                     :boolean          default(FALSE)
#  phone                         :string(255)
#  phone_verified                :boolean          default(FALSE)
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :integer
#
require 'rails_helper'

RSpec.describe CollegeStudent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
