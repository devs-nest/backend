# frozen_string_literal: true

class Group < ApplicationRecord
  # belongs_to :batch
  has_many :group_members
end
