# frozen_string_literal: true

class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearchtree queues heaps dynamicprogramming backtracking]
  has_many :algo_submission
end
