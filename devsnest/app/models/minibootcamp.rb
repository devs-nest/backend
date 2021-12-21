# frozen_string_literal: true

# Minibootcamp resourses
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic module]
  has_many :frontend_questions
  serialize :open_paths, Array
  serialize :protected_paths, Array

  def get_files_from_s3
    
  end
end
