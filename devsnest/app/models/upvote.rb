# frozen_string_literal: true

class Upvote < ApplicationRecord
  belongs_to :content, polymorphic: true
end
