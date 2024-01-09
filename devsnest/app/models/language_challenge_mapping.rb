# frozen_string_literal: true

# LanguageChallengeMapping Model
class LanguageChallengeMapping < ApplicationRecord
  belongs_to :challenge
  belongs_to :language
end