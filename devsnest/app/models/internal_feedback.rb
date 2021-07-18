# frozen_string_literal: true

# internal feedback or report an issue
class InternalFeedback < ApplicationRecord
  # 0 means scale not set
  validates :issue_scale, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10 }
  belongs_to :user

  def self.to_csv
    attributes = %w[id user_id issue_type issue_described feedback issue_scale]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
