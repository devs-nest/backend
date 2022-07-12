# frozen_string_literal: true

# Model for Discussion
class Discussion < ApplicationRecord
  has_many :upvotes, as: :content
  belongs_to :user
  belongs_to :challenge
  before_validation :create_slug, on: %i[create update]
  validates_uniqueness_of :slug, on: %i[create update], message: 'Slug must be unique'

  def create_slug
    update_attribute(:slug, "#{title}-#{SecureRandom.hex(3)}".parameterize)
  end
end
