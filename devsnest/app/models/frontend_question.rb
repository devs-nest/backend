# frozen_string_literal: true

# frontend submission model
class FrontendQuestion < ApplicationRecord
  has_one :minibootcamp
  has_many :minibootcamp_submissions
  serialize :open_paths, Array
  serialize :protected_paths, Array
  serialize :hidden_files, Array
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]
end
