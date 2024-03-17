# frozen_string_literal: true

# Model for user article activity
class UserArticleActivity < ApplicationRecord
  belongs_to :user
  belongs_to :article
end
