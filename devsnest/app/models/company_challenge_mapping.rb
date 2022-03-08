# frozen_string_literal: true

# CompanyChallengeMapping model
class CompanyChallengeMapping < ApplicationRecord
  belongs_to :challenge
  belongs_to :company
  validates :company_id, uniqueness: { scope: :challenge_id }
end
