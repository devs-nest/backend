# frozen_string_literal: true

# Model for Tenant
class Tenant < ApplicationRecord
  has_many :courses
  has_many :course_modules
  has_many :groups
end
