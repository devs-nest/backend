# frozen_string_literal: true

class AlgoTemplate < ApplicationRecord
  enum language: %i[python python3 java cpp c javascript typescript]
  belongs_to :challenge
end
