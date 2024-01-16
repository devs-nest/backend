# frozen_string_literal: true

# Model for sql challenges
class SqlChallenge < ApplicationRecord
  belongs_to :user
end

