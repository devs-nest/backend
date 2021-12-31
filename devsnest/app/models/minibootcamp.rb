# frozen_string_literal: true

# Minibootcamp resourses
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic]
  belongs_to :frontend_question
end
