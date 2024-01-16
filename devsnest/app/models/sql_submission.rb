# frozen_string_literal: true

# Model for sql submissions
class SqlSubmission < ApplicationRecord
  belongs_to :user
  belongs_to :sql_challenge
end
