# frozen_string_literal: true

class Reward < ApplicationRecord
  has_many :coin_log, as: :pointable, dependent: :destroy
end
