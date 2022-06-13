# frozen_string_literal: true

class Referral < ApplicationRecord
  validates :referred_user_id, uniqueness: true
end
