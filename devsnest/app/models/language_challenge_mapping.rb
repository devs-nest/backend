# frozen_string_literal: true

# LanguageChallengeMapping Model
class LanguageChallengeMapping < ApplicationRecord
  belongs_to :challenge
  belongs_to :language

  validates :challenge_id, uniqueness: { scope: :language_id }
end