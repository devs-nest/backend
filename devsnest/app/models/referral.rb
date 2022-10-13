# frozen_string_literal: true

# == Schema Information
#
# Table name: referrals
#
#  id               :bigint           not null, primary key
#  referral_code    :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  referred_user_id :integer
#
class Referral < ApplicationRecord
  has_many :coin_log, as: :pointable
  validates_uniqueness_of :referred_user_id, case_sensitive: true

  def title
    'Refferal points'
  end

  def description
    'Ponits credited for referring a new user'
  end
end
