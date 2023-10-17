# frozen_string_literal: true

# == Schema Information
#
# Table name: college_profiles
#
#  id                   :bigint           not null, primary key
#  authority_level      :integer
#  department           :integer
#  email                :string(255)
#  roll_number          :string(255)      not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  college_id           :integer
#  college_structure_id :integer
#  user_id              :integer
#
# Indexes
#
#  index_college_profiles_on_email        (email) UNIQUE
#  index_college_profiles_on_roll_number  (roll_number) UNIQUE
#
class CollegeProfile < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :college, optional: true
  belongs_to :college_structure, optional: true
  has_one :college_invites
  enum authority_level: %i[superadmin admin head student]

  validates_presence_of :email
  validates_uniqueness_of :roll_number

  def is_admin?
    authority_level.zero?
  end
end
