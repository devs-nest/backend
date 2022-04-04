# frozen_string_literal: true

class Unsubscribe < ApplicationRecord
  belongs_to :user
  validates :user_id, uniqueness: { scope: :category }
  enum category: %i[default]
end
