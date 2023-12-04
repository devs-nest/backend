# frozen_string_literal: true

# access management for bootcamp
class BootcampAccess < ApplicationRecord
  belongs_to :accessible, polymorphic: true
  belongs_to :course

  enum status: %i[requested payment_pending granted]
end
