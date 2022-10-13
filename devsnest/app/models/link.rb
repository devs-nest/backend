# frozen_string_literal: true

# == Schema Information
#
# Table name: links
#
#  id      :bigint           not null, primary key
#  address :text(65535)
#  slug    :string(255)
#
# Indexes
#
#  index_links_on_slug  (slug) UNIQUE
#
class Link < ApplicationRecord
  # self.primary_key = :slug
  validates_presence_of :address
  validates :address, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
end
