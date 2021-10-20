# frozen_string_literal: true

# internal feedback or report an issue
class InternalFeedback < ApplicationRecord
  # 0 means scale not set
  validates :issue_scale, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  belongs_to :user
end
