# == Schema Information
#
# Table name: college_invites
#
#  id                 :bigint           not null, primary key
#  authority_level    :integer
#  status             :integer          default("pending")
#  uid                :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  college_profile_id :integer
#
class CollegeInvites < ApplicationRecord

  belongs_to :college_profile
  enum status: %i[pending expired closed]
end
