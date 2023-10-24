# frozen_string_literal: true

# == Schema Information
#
# Table name: college_invites
#
#  id                 :bigint           not null, primary key
#  authority_level    :integer
#  status             :integer          default("pending")
#  uid                :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  college_id         :integer
#  college_profile_id :integer
#
class CollegeInvite < ApplicationRecord
  belongs_to :college_profile
  belongs_to :college
  enum status: %i[pending accepted]
end
