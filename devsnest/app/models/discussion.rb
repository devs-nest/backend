# frozen_string_literal: true

class Discussion < ApplicationRecord
  has_many :upvotes, as: :content
  belongs_to :user
  belongs_to :challenge
end
