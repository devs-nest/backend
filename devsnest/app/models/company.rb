# frozen_string_literal: true

# Company model
class Company < ApplicationRecord
  has_many :company_challenge_mappings
  has_many :challenges, through: :company_challenge_mappings
  validates_uniqueness_of :name
end
