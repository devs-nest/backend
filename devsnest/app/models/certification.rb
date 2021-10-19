# frozen_string_literal: true

# Certification Model
class Certification < ApplicationRecord
  belongs_to :user

  before_create do
    self.uuid = SecureRandom.base64(8).gsub('/', '_').gsub(/=+$/, '')
  end
end
