# frozen_string_literal: true

# Minibootcamp resourses
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic module]
  has_many :frontend_questions
end
