# frozen_string_literal: true

class Challenge < ApplicationRecord
  enum difficulty: %i[easy medium hard]
  enum topic: %i[arrays strings hashmap tree matrix graph linkedlist stacks binarysearch queues heaps dynamicprogramming backtracking greedy maths]
  has_many :algo_submission
  has_many :testcase
  validates_uniqueness_of :name, :slug
end
