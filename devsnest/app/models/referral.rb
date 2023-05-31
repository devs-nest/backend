# frozen_string_literal: true

# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  referral_code    :string(255)
#  referral_type    :integer          default("devsnest_registration")
#  referred_by      :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  referred_user_id :integer
#
class Referral < ApplicationRecord
  has_many :coin_log, as: :pointable
  validates :referred_user_id, uniqueness: { scope: [:referral_type] }
  enum referral_type: %i[devsnest_registration college]

  def title
    'Refferal points'
  end

  def description
    'Ponits credited for referring a new user'
  end
end
