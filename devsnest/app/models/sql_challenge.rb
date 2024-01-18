# frozen_string_literal: true

# Model for sql challenges
class SqlChallenge < ApplicationRecord
  belongs_to :user
  before_save { self.slug = name.parameterize }
end
