# frozen_string_literal: true

# College model
class CollegeForm < ApplicationRecord
  validates_uniqueness_of :user_id
end
