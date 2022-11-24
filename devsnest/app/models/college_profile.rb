# == Schema Information
#
# Table name: college_profiles
#
#  id              :bigint           not null, primary key
#  authority_level :integer
#  department      :integer
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  college_id      :integer
#  user_id         :integer
#
# Indexes
#
#  index_college_profiles_on_email  (email) UNIQUE
#
class CollegeProfile < ApplicationRecord

  belongs_to :user, optional: true
  belongs_to :college, optional: true
  has_one :college_invites
  enum authority_level: %i[superadmin admin head]
  many_to_many :college_structures, through: :college_structure_mappings

  validates_presence_of :email
end
