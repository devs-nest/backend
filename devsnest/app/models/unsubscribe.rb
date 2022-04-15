# frozen_string_literal: true

class Unsubscribe < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :category
  enum category: %i[default]
end
