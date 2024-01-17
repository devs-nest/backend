# frozen_string_literal: true

# Model for sql challenges
class SqlChallenge < ApplicationRecord
  belongs_to :user
  enum submission_status: %i[unsolved solved]
  before_save { self.slug = name.parameterize }
end
