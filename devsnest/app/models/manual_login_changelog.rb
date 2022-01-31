# frozen_string_literal: true

class ManualLoginChangelog < ApplicationRecord
  belongs_to :user
  enum query_type: %i[verification password_reset]

  def within_a_day?
    created_at + 24.hours > Time.now
  end
end
