# frozen_string_literal: true

class Scrum < ApplicationRecord
  validates :user_id, uniqueness: { scope: :creation_date }

  before_create do
      self.creation_date = Date.current
  end
end
