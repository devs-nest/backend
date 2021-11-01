# frozen_string_literal: true

# content class
class Content < ApplicationRecord
  enum data_type: %i[question video article topic subtopic]
  enum difficulty: %i[easy medium hard]
  enum question_type: %i[class assignment]
  has_many :submission

  def self.split_by_difficulty
    Content.where(data_type: 'question').group(:difficulty).count
  end
end
