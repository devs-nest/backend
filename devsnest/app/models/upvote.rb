# frozen_string_literal: true

class Upvote < ApplicationRecord
  belongs_to :content, polymorphic: true
  belongs_to :user
  validates :user_id, uniqueness: { scope: %i[content_id content_type] }
end
