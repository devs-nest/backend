# frozen_string_literal: true

# Model for sql challenges
class SqlChallenge < ApplicationRecord
  belongs_to :user
  enum difficulty: %i[easy_level medium_level hard_level]
  before_save { self.slug = name.parameterize }
end
