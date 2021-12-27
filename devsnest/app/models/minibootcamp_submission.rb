class MinibootcampSubmission < ApplicationRecord
  serialize :open_paths, Array
  serialize :protected_paths, Array
  enum template: %i[angular react react-ts vanilla vanilla-ts vue vue3 svelte]
end