# frozen_string_literal: true

# == Schema Information
#
# Table name: discussions
#
#  id            :bigint           not null, primary key
#  body          :text(65535)
#  question_type :string(255)
#  slug          :string(255)
#  title         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  parent_id     :integer
#  question_id   :integer
#  user_id       :integer
#
# Indexes
#
#  index_discussions_on_question_id_and_parent_id  (question_id,parent_id)
#  index_discussions_on_slug                       (slug) UNIQUE
#  index_discussions_on_user_id                    (user_id)
#
class Discussion < ApplicationRecord
  has_many :upvotes, as: :content
  belongs_to :user
  belongs_to :question, polymorphic: true
  before_validation :create_slug, on: %i[create]
  validates_uniqueness_of :slug, on: %i[create update], message: 'Slug must be unique'

  def create_slug
    update_attribute(:slug, "#{title}-#{SecureRandom.hex(3)}".parameterize)
  end
end
