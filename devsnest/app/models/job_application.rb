# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job

  enum status: %i[applied interview offer rejected]
end
