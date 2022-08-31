# frozen_string_literal: true

class CoinLog < ApplicationRecord
  belongs_to :pointable, polymorphic: true
  belongs_to :user
end
