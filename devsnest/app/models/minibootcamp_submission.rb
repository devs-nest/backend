class MinibootcampSubmission < ApplicationRecord
  serialize :open_paths, Array
  serialize :protected_paths, Array
end