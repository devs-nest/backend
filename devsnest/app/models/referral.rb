# frozen_string_literal: true

class Referral < ApplicationRecord
  has_many :coin_log, as: :pointable
  validates_uniqueness_of :referred_user_id, case_sensitive: true
end
