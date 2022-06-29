# frozen_string_literal: true

class Referral < ApplicationRecord
  validates_uniqueness_of :referred_user_id, case_sensitive: true
end
