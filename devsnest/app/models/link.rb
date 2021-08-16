# frozen_string_literal: true

class Link < ApplicationRecord
  # self.primary_key = :slug
  validates_presence_of :address
end
