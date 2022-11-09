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
class CollegeProfile < ApplicationRecord

  belongs_to :user, optional: true
  has_one :college_invite
  enum authority_level: %i[superadmin admin head]
end
