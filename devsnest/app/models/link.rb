# frozen_string_literal: true

class Link < ApplicationRecord
  # self.primary_key = :slug
  validates_presence_of :address
  validates :address, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
